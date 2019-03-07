import 'dart:async';
import 'package:chessbotsmobile/bloc/firestore.bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import './base.bloc.dart';
import '../models/gambit.dart';
import 'package:chess/chess.dart' as chess;
import '../shared/gambits.dart';

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

class AddEmptyGambitEvent extends ChessBotEvent {}

class ChessBot implements BlocBase {
  // firestore fields that can be directly ported
  String uid;
  String name;
  int kills;
  int level;
  int value;
  String status; //TODO enum status some how

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
      this.value,
      this.kills,
      this.level,
      this.botRef}) {
    this._gambits = gambits ?? [EmptyGambit()];

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
      syncWithFirestore();
    } else if (event is DismissedEvent) {
      int index = event.index;
      _gambits[index] = EmptyGambit();
      syncWithFirestore();
    } else if (event is SelectGambitEvent) {
      int index = event.index;
      Gambit selectedGambit = event.selectedGambit;
      _gambits[index] = selectedGambit;
      syncWithFirestore();
    } else if (event is DeleteBotDocEvent) {
      int _reward = (value / 2).round();
      if (_reward > 0) {
        FirestoreBloc().userEvent.add(AwardNerdPointsEvent(_reward));
      }
      // remove reference in user doc
      FirestoreBloc().userEvent.add(RemoveBotRef(botRef));
      await botRef.delete();
    } else if (event is AddEmptyGambitEvent) {
      _gambits.contains(EmptyGambit())
          ? print("cannot add another empty slot")
          : _gambits.add(EmptyGambit());
      //TODO send error message to toaster service
      //TODO spend nerd points/ update userdoc
    } else if (event is RepairBotEvent) {
      //sanity check that it is really broken
      if (status != "damaged") {
        return;
      }
      int _cost = (value / 2).round();
      await FirestoreBloc().spendNerdPoints(_cost).then((_) {
        status = "ready";
        syncWithFirestore();
      }).catchError((e) {
        //TODO push to alert dialog bloc after it is built
        print("Problem repairing");
      });
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
  void syncWithFirestore() async {
    botRef.setData(serialize(), merge: true);
  }

  // external methods
  /// find a move by going through all gambits, in order
  String waterfallGambits(chess.Chess game) {
    // find the gambit to be used
    // add it to internal in
    // return the move
    List<Gambit> _gambitsToBeTested = [CheckmateOpponent()];
    _gambitsToBeTested.addAll(_gambits);
    Gambit _gambitToBeUsed = _gambitsToBeTested.firstWhere(
      (_gambit) => _gambit.findMove.call(game) != null,
      orElse: () => MoveRandomPiece(),
    );
    _internalInLastUsedGambit.add(_gambitToBeUsed);

    String move = _gambitToBeUsed.findMove(game);
    return move;
  }

  /// Create a ChessBot using a firestore document reference
  ChessBot.marshal(this.botRef) {
    // ChessBot.marshal(Map<String, dynamic> _snapshotData) {
    // Map<String, dynamic> _snapshotData =
    botRef.snapshots().listen((snap) {
      final _snapshotData = snap.data;
      this.uid = _snapshotData["uid"];
      this.name = _snapshotData["name"] ?? "Your bot";
      this.level = _snapshotData["level"];
      this.kills = _snapshotData["kills"];
      this.value = _snapshotData["value"];
      this.status = _snapshotData["status"];

      List<String> gambitNames = [];
      if (_snapshotData["gambits"] != null) {
        _snapshotData["gambits"].forEach((element) {
          if (element is String) {
            gambitNames.add(element);
          }
        });
      }

      this._gambits = gambitNames.map((name) => gambitMap[name]).toList() ??
          [EmptyGambit(), CheckOpponent()];

      // pushing the initial gambits out of the stream
      _internalInGambits.add(_gambits);

      // connect external-in to internal-out
      _eventController.stream.listen(_handleEvent);
    });
  }

  /// Output this ChessBot to firestore-friendly format
  Map<String, dynamic> serialize() {
    Map<String, dynamic> _map = {
      "uid": uid,
      "name": name,
      "level": level,
      "kills": kills,
      "value": value,
      "status": status,
      "gambits": _gambits.map((gambit) => gambit.title).toList(),
    };
    return _map;
  }
}

//TODO is there a better home for this?
/// Given a title, returns the matching gambit
Map<String, Gambit> gambitMap = {
  CaptureBishop().title: CaptureBishop(),
  CaptureKnight().title: CaptureKnight(),
  CapturePawn().title: CapturePawn(),
  CaptureQueen().title: CaptureQueen(),
  CaptureRook().title: CaptureRook(),
  CastleKingSide().title: CastleKingSide(),
  CastleQueenSide().title: CastleQueenSide(),
  CheckOpponent().title: CheckOpponent(),
  MoveRandomPawn().title: MoveRandomPawn(),
  PawnToE4().title: PawnToE4(),
  PromotePawnToBishop().title: PromotePawnToBishop(),
  PromotePawnToKnight().title: PromotePawnToKnight(),
  PromotePawnToQueen().title: PromotePawnToQueen(),
  PromotePawnToRandom().title: PromotePawnToRandom(),
  PromotePawnToRook().title: PromotePawnToRook(),
  EmptyGambit().title: EmptyGambit(),
};

Observable<ChessBot> marshalChessBot(DocumentReference botRef) {
  return Observable(botRef.snapshots().map((snap) {
    final _snapshotData = snap.data;
    final uid = _snapshotData["uid"];
    final name = _snapshotData["name"] ?? "Your bot";
    final level = _snapshotData["level"];
    final kills = _snapshotData["kills"];
    final value = _snapshotData["value"];
    final status = _snapshotData["status"];
    List<String> _gambitNames = [];
    if (_snapshotData["gambits"] != null) {
      _snapshotData["gambits"].forEach((element) {
        if (element is String) {
          _gambitNames.add(element);
        }
      });
    }
    final gambits =
        _gambitNames.map((name) => gambitMap[name]).toList() ?? [EmptyGambit()];
    return ChessBot(
      uid: uid,
      name: name,
      level: level,
      kills: kills,
      value: value,
      status: status,
      gambits: gambits,
      botRef: botRef,
    );
  })).shareValue();
}
