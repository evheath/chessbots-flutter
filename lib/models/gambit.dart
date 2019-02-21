import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class Gambit {
  IconData icon;
  Color color;
  String title;
  String description;

  Gambit({
    // TODO perhaps have initial data?
    @required this.icon,
    @required this.color,
    @required this.title,
    @required this.description,
  });

  /// findMove must always be overwritten
  ///
  /// accepts a chess game and returns a move to be made
  String findMove(chess.Chess game) {
    throw Exception("findMove was not overwritten");
  }
}
