import 'package:flutter/material.dart';

/// singletons should be extended off of this class
/// and stored in the /shared/gambits folder
abstract class Gambit {
  IconData icon;
  Color color;
  String title;
  String description;

  /// catch phrase for a gambit
  String altText;
  CustomPaint vector;
  String demoFEN;

  int cost;

  /// Function that, given a chess object, will return a move as a string
  ///
  /// If no move is found, null should be returned
  Function findMove;

  Gambit({
    @required this.icon,
    @required this.color,
    @required this.title,
    @required this.description,
    @required this.findMove,
    this.vector,
    this.demoFEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    @required this.altText,
    @required this.cost,
  });

  /// returns a square when given a legal move
  ///
  /// e.g. exf4 -> f4 or Bxf5=Q+ -> f5
  static String landingSquareOfMove(dynamic move) {
    String everythingBeforeAnX =
        move.toString().replaceAll(RegExp(r"(.*)x"), '');

    String noPieces = everythingBeforeAnX.replaceAll(RegExp(r"[NBRQKx=+]"), '');

    String lastTwoLetters = noPieces.substring(noPieces.length - 2);

    return lastTwoLetters;
  }
}
