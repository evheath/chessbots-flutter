import 'dart:async';
import 'package:rxdart/subjects.dart';

import './base.bloc.dart';

import '../models/gambit.dart';

import 'package:chess/chess.dart' as chess;

//TODO remove this import, this is just used for testing purpose,
// eventually the gambits should be obtained programmatically
import '../shared/gambits.dart';

abstract class GambitEvent {}

class ReorderEvent extends GambitEvent {
  int oldIndex;
  int newIndex;

  ReorderEvent(
    this.oldIndex,
    this.newIndex,
  );
}

class DismissedEvent extends GambitEvent {
  int index;

  DismissedEvent(
    this.index,
  );
}

class SelectGambitEvent extends GambitEvent {
  int index;
  Gambit selectedGambit;

  SelectGambitEvent(this.index, this.selectedGambit);
}

class GambitsBloc implements BlocBase {
  // state
  List<Gambit> _gambits = [
    // CapturePawn(),
    // CaptureKnight(),
    EmptyGambit(),
    // CaptureBishop(),
    // CaptureRook(),
    // CaptureQueen(),
    // PromotePawnToKnight(),
    // PromotePawnToBishop(),
    // PromotePawnToRook(),
    // PromotePawnToQueen(),
    // PromotePawnToRandom(),
    // MoveRandomPawn(),
    CheckOpponent(),
    // CastleQueenSide(),
    // CaptureRandomPiece(),
    // CastleKingSide(),
  ];

  // controllers
  StreamController<List<Gambit>> _gambitsController =
      BehaviorSubject<List<Gambit>>();
  StreamController<GambitEvent> _eventController = StreamController();

  // external-in
  StreamSink<GambitEvent> get event => _eventController.sink;

  GambitsBloc() {
    //TODO implement how gambits get intially set
    _gambits.shuffle();
    // pushing the initial gambits out of the stream
    _internalIn.add(_gambits);

    // connect external-in to internal-out
    _eventController.stream.listen(_handleEvent);
  }
  // internal-out
  void _handleEvent(GambitEvent event) {
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
    } else if (event is DismissedEvent) {
      int index = event.index;
      _gambits[index] = EmptyGambit();
    } else if (event is SelectGambitEvent) {
      int index = event.index;
      Gambit selectedGambit = event.selectedGambit;
      _gambits[index] = selectedGambit;
    }
    // connect internal-out to internal-in
    _internalIn.add(_gambits);
  }

  // internal-in
  StreamSink<List<Gambit>> get _internalIn => _gambitsController.sink;

  // external-out (inherently connected to internal-in via controller)
  Stream<List<Gambit>> get gambits => _gambitsController.stream;

  // tear down
  void dispose() {
    _eventController.close();
    _gambitsController.close();
  }

  // external methods
  /// find a move by going through all gambits, in order
  String waterfallGambits(chess.Chess game) {
    // find the first gambit that returns a move, then get and return that move
    // first we look to see if we can simply checkmate the opponent this turn,
    // if eventually no gambit can find a move, we just return a random/legal move
    String move = CheckmateOpponent().findMove(game) ??
        _gambits
            .firstWhere(
              (gambit) => gambit.findMove.call(game) != null,
              orElse: () => MoveRandomPiece(),
            )
            .findMove(game);
    return move;
  }

  /// similar to waterfallGambits, but returns the gambit itself, not the move
  Gambit gambitToBeUsed(chess.Chess game) {
    // first we look to see if we can simply checkmate the opponent this turn,
    // then try to find the first gambit that returns a move
    // if no gambit can find a move, we just return MoveRandomPiece

    List<Gambit> _gambitsToBeTested = [CheckmateOpponent()];
    _gambitsToBeTested.addAll(_gambits);
    // _gambitsToBeTested.add(MoveRandomPiece());
    // print("legal moves are ${game.moves()}");
    Gambit _returningGambit = _gambitsToBeTested.firstWhere(
      (_gambit) => _gambit.findMove.call(game) != null,
      orElse: () => MoveRandomPiece(),
    );
    return _returningGambit;
  }
}
