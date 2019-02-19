import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:chess/chess.dart';

class LabBloc {
  Chess _game;

  // out
  StreamController<String> _fenController = BehaviorSubject<String>();
  Stream<String> get fen => _fenController.stream;

  // in
  StreamController<String> _eventController = StreamController();
  StreamSink get fenIn => _eventController.sink;

  // constructor
  LabBloc() {
    _game = Chess();
    fenIn.add(_game.fen); // setting the initial snapshot

    // Bloc is listening for events
    _eventController.stream.listen(_handleFenIn);
  }

  // Private methods

  void _handleFenIn(String data) {
    // if (data != null) {
    // _fen = data;
    // } else {
    //   _fen = 'I was given empty data';
    // }
    _fenController.sink.add(data);
  }

  void _handleMove(dynamic move) {
    _game.move(move);

    _fenController.sink.add(_game.fen);
  }

  // Public methods

  void dispose() {
    _eventController.close();
    _fenController.close();
  }

  void randomMove() {
    List<dynamic> moves = _game.moves();
    moves.shuffle();
    dynamic move = moves[0];
    _handleMove(move);
  }
}
