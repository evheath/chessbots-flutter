import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';

import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CapturePawn extends Gambit {
  // singleton logic so that CapturePawn is only created once
  static final CapturePawn _singleton = CapturePawn._internal();
  factory CapturePawn() => _singleton;

  CapturePawn._internal()
      : super(
            cost: 2,
            demoFEN:
                "rnbqkbnr/pppp1ppp/8/6N1/4p3/2P3P1/PPQPPPBP/RNB1K2R w KQkq - 0 1",
            vector: WhitePawn(),
            title: "Random takes Pawn",
            color: Colors.red,
            description: "Take a pawn using any available piece.",
            altText: "Small victories.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              captures.shuffle();
              String move = captures.firstWhere(
                (capture) {
                  String landingSquare = Gambit.landingSquareOfMove(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare)?.type;
                  return pieceBeingCaptured == chess.PieceType.PAWN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
