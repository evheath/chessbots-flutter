import 'dart:async';
import 'package:rxdart/subjects.dart';
import './base.bloc.dart';
import '../models/gambit.dart';
import 'package:chess/chess.dart' as chess;
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

class ChessBot implements BlocBase {
  // state
  List<Gambit> _gambits;
  String botName;

  // controllers
  StreamController<List<Gambit>> _gambitsController =
      BehaviorSubject<List<Gambit>>();
  StreamController<GambitEvent> _eventController = StreamController();
  StreamController<Gambit> _lastUsedGambitController =
      StreamController.broadcast();

  // external-in
  StreamSink<GambitEvent> get event => _eventController.sink;

  ChessBot({List<Gambit> gambits, this.botName = 'Bot'}) {
    this._gambits = gambits ?? [EmptyGambit(), CheckOpponent()];

    // pushing the initial gambits out of the stream
    _internalInGambits.add(_gambits);

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
}
