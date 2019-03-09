import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class MovePieceSafely extends Gambit {
  // singleton logic so that MovePieceSafely is only created once
  static final MovePieceSafely _singleton = MovePieceSafely._internal();
  factory MovePieceSafely() => _singleton;

  MovePieceSafely._internal()
      : super(
            cost: 5,
            demoFEN:
                'r2qk1r1/1pp1bp2/p1npbnpp/4p1B1/3PP3/N1P2N2/PPQ2PPP/R3KB1R w KQkq - 0 1',
            title: "Move piece safely",
            color: Colors.grey,
            description: "Move a random piece to an unattacked square.",
            altText: "Includes captures!",
            icon: FontAwesomeIcons.question,
            findMove: FindMove((chess.Chess game) {
              final enemyColor = game.turn == chess.Color.WHITE
                  ? chess.Color.BLACK
                  : chess.Color.WHITE;

              List<dynamic> moves = game.moves();
              moves.shuffle();

              String move = moves.firstWhere(
                (possibleMove) {
                  String stringOfLandingSquare = Gambit.squareOf(possibleMove);
                  if (stringOfLandingSquare == null ||
                      stringOfLandingSquare.isEmpty) {
                    print(
                        "stringOfLandingSquare is $stringOfLandingSquare but the possible move was $possibleMove");
                    return false;
                  }
                  int landingSquareAsInt =
                      chess.Chess.SQUARES[stringOfLandingSquare];
                  if (landingSquareAsInt == null) {
                    print(
                        'landingSquareAsInt null but the possible move was $possibleMove and the stringOfLandingSquare was $stringOfLandingSquare');
                    return false;
                  }
                  return !game.attacked(enemyColor, landingSquareAsInt);
                },
                orElse: () => null,
              );

              return move;
            }));
}
