import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

/// this class is used to create a pseudofunction
///
/// that function will act as the logic for find a move for a particular gambit
class FindMove {
  Function _func;

  FindMove(this._func);

  String call(chess.Chess game) => _func(game);
}

/// singletons should be extended off of this class
/// and stored in the /shared/gambits folder
abstract class Gambit {
  IconData icon;
  Color color;
  String title;
  String description;

  /// Function that, given a chess object, can find a move
  FindMove findMove;

  Gambit({
    @required this.icon,
    @required this.color,
    @required this.title,
    @required this.description,
    @required this.findMove,
  });
}
