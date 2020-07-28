import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

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

  /// Function that, given a chess object, will return a move as a string (in SAN; standard algebraic notation)
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
  /// e.g. exf4 -> f4 or gxf8=Q+ -> f8
  static String landingSquareOfMove(dynamic move) {
    String everythingBeforeAnX =
        move.toString().replaceAll(RegExp(r"(.*)x"), '');

    String noPieces = everythingBeforeAnX.replaceAll(RegExp(r"[NBRQKx=+]"), '');

    String lastTwoLetters = noPieces.substring(noPieces.length - 2);

    return lastTwoLetters;
  }

  /// returns true if given move cannot result in an immediate recapture
  static bool safeMove(chess.Move moveInQuestion, chess.Chess game) {
    // create a hypothetical game
    // so we can make the move w/o impacting the game in question
    chess.Chess hypotheticalGame = new chess.Chess();
    hypotheticalGame.load(game.generate_fen());

    // make the given move and keep track of the square-in-question
    int landingSquareInQuestion = moveInQuestion.to;
    hypotheticalGame.move(moveInQuestion);

    // check the now-possible moves for a recapture
    List<chess.Move> nowPossibleMoves = hypotheticalGame.generate_moves();

    // return false if the opponent can move to the same square on their next turn
    return !nowPossibleMoves.any(
        (nowPossibleMove) => nowPossibleMove.to == landingSquareInQuestion);
  }
}
