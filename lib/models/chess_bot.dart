import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/shared/gambits.dart';
import 'package:chessbotsmobile/shared/gambits/capture_random_using_bishop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:chess/chess.dart' as chess;

abstract class ChessBotEvent {}

/// For when gambits have changed order
class ReorderEvent extends ChessBotEvent {
  int oldIndex;
  int newIndex;

  ReorderEvent(
    this.oldIndex,
    this.newIndex,
  );
}

/// For when a gambit is emptied
class DismissedEvent extends ChessBotEvent {
  int index;

  DismissedEvent(
    this.index,
  );
}

/// For when an empty gambit needs to be filled
class SelectGambitEvent extends ChessBotEvent {
  int index;
  Gambit selectedGambit;

  SelectGambitEvent(this.index, this.selectedGambit);
}

class DeleteBotDocEvent extends ChessBotEvent {}

class ChessBot {
  // firestore fields that can be directly ported
  String uid;
  String name;
  int kills;
  String status;

  // fields that require conversion
  List<Gambit> _gambits;

  // other firestore data
  DocumentReference botRef;

  // controllers
  StreamController<List<Gambit>> _gambitsController =
      BehaviorSubject<List<Gambit>>();
  StreamController<ChessBotEvent> _eventController = StreamController();
  StreamController<Gambit> _lastUsedGambitController =
      StreamController.broadcast();

  // external-in
  StreamSink<ChessBotEvent> get event => _eventController.sink;

  //constructors
  ChessBot(
      {List<Gambit> gambits,
      this.name = 'Bot',
      this.uid,
      this.status,
      this.kills = 0,
      this.botRef}) {
    this._gambits = gambits ?? [EmptyGambit()];

    // pushing the initial gambits out of the stream
    _internalInGambits.add(_gambits);

    // connect external-in to internal-out
    _eventController.stream.listen(_handleEvent);
  }

  ChessBot.fromSnapshot(DocumentSnapshot _documentSnapshot) {
    this.botRef = _documentSnapshot.reference;
    final _snapshotData = _documentSnapshot.data;
    this.uid = _snapshotData["uid"];
    this.name = _snapshotData["name"] ?? "Your bot";
    this.kills = _snapshotData["kills"];
    this.status = _snapshotData["status"];
    List<String> _gambitNames = [];
    if (_snapshotData["gambits"] != null) {
      _snapshotData["gambits"].forEach((element) {
        if (element is String) {
          _gambitNames.add(element);
        }
      });
    }
    this._gambits =
        _gambitNames.map((name) => gambitMap[name]).toList() ?? [EmptyGambit()];

    // pushing the initial gambits out of the stream
    _internalInGambits.add(_gambits);

    // connect external-in to internal-out
    _eventController.stream.listen(_handleEvent);
  }

  // internal-out
  void _handleEvent(ChessBotEvent event) async {
    if (event is ReorderEvent) {
      int oldIndex = event.oldIndex;
      int newIndex = event.newIndex;
      if (oldIndex >= _gambits.length) {
        // user tried to move the unconfigurable gambit tiles up
        return;
      }
      if (newIndex > _gambits.length) {
        // user tried to move a gambit passed unconfigurable gambit tiles
        // so it should just be dropped to the last
        newIndex = _gambits.length;
      }
      if (oldIndex < newIndex) {
        // removing the item at oldIndex will shorten the list by 1.
        newIndex -= 1;
      }
      final Gambit movedGambit = _gambits.removeAt(oldIndex);
      _gambits.insert(newIndex, movedGambit);
      _syncWithFirestore();
    } else if (event is DismissedEvent) {
      int index = event.index;
      _gambits[index] = EmptyGambit();
      _syncWithFirestore();
    } else if (event is SelectGambitEvent) {
      int index = event.index;
      Gambit selectedGambit = event.selectedGambit;
      _gambits[index] = selectedGambit;
      _syncWithFirestore();
    } else if (event is DeleteBotDocEvent) {
      if (sellValue > 0) {
        FirestoreBloc().userEvent.add(AwardNerdPointsEvent(sellValue));
      }
      // remove reference in user doc
      FirestoreBloc().userEvent.add(RemoveBotRef(botRef));
      await botRef.delete();
    }

    // connect internal-out to internal-in
    // (let listeners know about the gambits)
    _internalInGambits.add(_gambits);
  }

  // internal-in
  StreamSink<List<Gambit>> get _internalInGambits => _gambitsController.sink;
  StreamSink<Gambit> get _internalInLastUsedGambit =>
      _lastUsedGambitController.sink;

  // external-out (inherently connected to internal-in via controller)
  Stream<List<Gambit>> get gambits => _gambitsController.stream;
  Stream<Gambit> get lastUsedGambit => _lastUsedGambitController.stream;

  // tear down
  void dispose() {
    _eventController.close();
    _gambitsController.close();
    _lastUsedGambitController.close();
  }

  // internal methods

  void _syncWithFirestore() async {
    botRef.setData(serialize(), merge: true);
  }

  int _calculateValue() {
    int sumOfAll(int number) => number <= 0 ? 1 : number + sumOfAll(number - 1);
    final int valueOfLevel = sumOfAll(level);

    final int valueOfGambits = _gambits
        .map((gambit) => gambit.cost)
        .reduce((int cost, int total) => cost + total);

    final int total = valueOfLevel + valueOfGambits;
    return total;
  }

  int _calculateLevel() {
    return _gambits.length;
  }

  // external methods
  int get value => _calculateValue();
  int get level => _calculateLevel();
  int get sellValue => (value / 2).floor() - 1;
  int get repairCost => (value / 2).floor() - 1;
  int get bounty {
    int _bounty = (value / 2).round();
    return _bounty > 0 ? _bounty : 1;
  }

  Map<String, dynamic> serialize() {
    Map<String, dynamic> _map = {
      "uid": uid,
      "name": name,
      "kills": kills,
      "status": status,
      "gambits": _gambits.map((gambit) => gambit.title).toList(),
    };
    return _map;
  }

  /// find a move by going through all gambits, in order
  String waterfallGambits(chess.Chess game) {
    // find the gambit to be used
    // add it to internal in
    // return the move
    List<Gambit> _gambitsToBeTested = [CheckmateOpponent()];
    _gambitsToBeTested.addAll(_gambits);
    Gambit _gambitToBeUsed = _gambitsToBeTested.firstWhere(
      (_gambit) => _gambit.findMove(game) != null,
      orElse: () => MoveRandomPiece(),
    );
    _internalInLastUsedGambit.add(_gambitToBeUsed);

    // String move = _gambitToBeUsed.findMove.call(game);
    String move = _gambitToBeUsed.findMove(game);
    return move;
  }

  // UI dependent methods
  Future<void> attemptRepair() async {
    //sanity check that it is really broken
    if (status != "damaged") {
      throw ("Bot does not need to be repaired");
    }
    return FirestoreBloc().attemptToSpendNerdPoints(repairCost).then((_) {
      status = "ready";
      _syncWithFirestore();
    });
  }

  int costOfUpgrading() {
    return level + 1;
  }

  Future<void> attemptLevelUp() async {
    await FirestoreBloc().attemptToSpendNerdPoints(costOfUpgrading()).then((_) {
      _gambits.add(EmptyGambit());
      _syncWithFirestore();
    });
  }
}

/// Given a title, returns the matching gambit
///
/// Used for building gambits from titles stored in db
Map<String, Gambit> gambitMap = {
  PromoteWithCapture().title: PromoteWithCapture(),
  MovePieceSafely().title: MovePieceSafely(),
  CaptureUndefendedPiece().title: CaptureUndefendedPiece(),
  CaptureRandomPiece().title: CaptureRandomPiece(),
  CaptureBishop().title: CaptureBishop(),
  CaptureRandomUsingPawn().title: CaptureRandomUsingPawn(),
  CaptureRookUsingPawn().title: CaptureRookUsingPawn(),
  CaptureBishopUsingPawn().title: CaptureBishopUsingPawn(),
  CaptureKnightUsingPawn().title: CaptureKnightUsingPawn(),
  CapturePawnUsingPawn().title: CapturePawnUsingPawn(),
  CaptureQueenUsingPawn().title: CaptureQueenUsingPawn(),
  CaptureRandomUsingBishop().title: CaptureRandomUsingBishop(),
  CaptureBishopUsingBishop().title: CaptureBishopUsingBishop(),
  CaptureKnightUsingBishop().title: CaptureKnightUsingBishop(),
  CapturePawnUsingBishop().title: CapturePawnUsingBishop(),
  CaptureRookUsingBishop().title: CaptureRookUsingBishop(),
  CaptureQueenUsingBishop().title: CaptureQueenUsingBishop(),
  CaptureRandomUsingKnight().title: CaptureRandomUsingKnight(),
  CaptureBishopUsingKnight().title: CaptureBishopUsingKnight(),
  CaptureKnightUsingKnight().title: CaptureKnightUsingKnight(),
  CapturePawnUsingKnight().title: CapturePawnUsingKnight(),
  CaptureRookUsingKnight().title: CaptureRookUsingKnight(),
  CaptureQueenUsingKnight().title: CaptureQueenUsingKnight(),
  CaptureQueenUsingQueen().title: CaptureQueenUsingQueen(),
  CaptureRookUsingQueen().title: CaptureRookUsingQueen(),
  CaptureBishopUsingQueen().title: CaptureBishopUsingQueen(),
  CaptureKnightUsingQueen().title: CaptureKnightUsingQueen(),
  CapturePawnUsingQueen().title: CapturePawnUsingQueen(),
  CaptureRandomUsingQueen().title: CaptureRandomUsingQueen(),
  CaptureBishopUsingKing().title: CaptureBishopUsingKing(),
  CaptureKnightUsingKing().title: CaptureKnightUsingKing(),
  CapturePawnUsingKing().title: CapturePawnUsingKing(),
  CaptureRookUsingKing().title: CaptureRookUsingKing(),
  CaptureQueenUsingKing().title: CaptureQueenUsingKing(),
  CaptureRandomUsingKing().title: CaptureRandomUsingKing(),
  CaptureRandomUsingRook().title: CaptureRandomUsingRook(),
  CapturePawnUsingRook().title: CapturePawnUsingRook(),
  CaptureRookUsingRook().title: CaptureRookUsingRook(),
  CaptureQueenUsingRook().title: CaptureQueenUsingRook(),
  CaptureKnightUsingRook().title: CaptureKnightUsingRook(),
  CaptureBishopUsingRook().title: CaptureBishopUsingRook(),
  DevelopKnight().title: DevelopKnight(),
  DevelopBishop().title: DevelopBishop(),
  DevelopQueen().title: DevelopQueen(),
  DevelopRook().title: DevelopRook(),
  DevelopPawn().title: DevelopPawn(),
  CaptureKnight().title: CaptureKnight(),
  CapturePawn().title: CapturePawn(),
  CaptureQueen().title: CaptureQueen(),
  CaptureRook().title: CaptureRook(),
  CastleKingSide().title: CastleKingSide(),
  CastleQueenSide().title: CastleQueenSide(),
  CheckOpponent().title: CheckOpponent(),
  MovePawn().title: MovePawn(),
  MoveKnight().title: MoveKnight(),
  MoveBishop().title: MoveBishop(),
  MoveRook().title: MoveRook(),
  MoveQueen().title: MoveQueen(),
  MoveKing().title: MoveKing(),
  MoveQueenSafely().title: MoveQueenSafely(),
  MoveRookSafely().title: MoveRookSafely(),
  // MovePawnSafely().title: MovePawnSafely(),
  // MoveKnightSafely().title: MoveKnightSafely(),
  // MoveBishopSafely().title: MoveBishopSafely(),
  PawnToE4().title: PawnToE4(),
  PromotePawnToBishop().title: PromotePawnToBishop(),
  PromotePawnToKnight().title: PromotePawnToKnight(),
  PromotePawnToQueen().title: PromotePawnToQueen(),
  PromotePawnToRandom().title: PromotePawnToRandom(),
  PromotePawnToRook().title: PromotePawnToRook(),
  EmptyGambit().title: EmptyGambit(),
};

/// Instaniate an observable ChessBot using a firestore document reference
Observable<ChessBot> marshalChessBot(DocumentReference botRef) {
  if (botRef == null) {
    return Observable.just(ChessBot(name: "Tap to Select")).shareValue();
  }
  return Observable(
          botRef.snapshots().map((snap) => ChessBot.fromSnapshot(snap)))
      .shareValue();
}
