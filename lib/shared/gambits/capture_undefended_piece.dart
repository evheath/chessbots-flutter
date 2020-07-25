import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureUndefendedPiece extends Gambit {
  // singleton logic so that CaptureUndefendedPiece is only created once
  static final CaptureUndefendedPiece _singleton =
      CaptureUndefendedPiece._internal();
  factory CaptureUndefendedPiece() => _singleton;

  CaptureUndefendedPiece._internal()
      : super(
            cost: 10,
            demoFEN:
                'rnb1k2r/1p1p1ppp/pqp4n/2b1p1N1/1PB5/8/PBPPPPPP/RN1QK2R w KQkq - 0 1',
            title: "Random takes Random, undefended",
            color: Colors.red,
            description:
                "Take a piece that has no defenders, using any piece of your own.",
            altText: "Defend your border, lest it turn into my border.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              final enemyColor = game.turn == chess.Color.WHITE
                  ? chess.Color.BLACK
                  : chess.Color.WHITE;

              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              captures.shuffle();
              String move = captures.firstWhere(
                (capture) {
                  String stringOfLandingSquare =
                      Gambit.landingSquareOfMove(capture);
                  int landingSquareAsInt =
                      chess.Chess.SQUARES[stringOfLandingSquare];
                  return !game.attacked(enemyColor, landingSquareAsInt);
                },
                orElse: () => null,
              );
              return move;
            }));
}
