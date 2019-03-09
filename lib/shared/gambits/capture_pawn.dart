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
            cost: 1,
            demoFEN:
                "rnbqkb1r/ppp1pppp/5n2/8/2pP4/4P3/PP3PPP/RNBQKBNR w KQkq - 0 1",
            vector: WhitePawn(),
            title: "Capture pawn",
            color: Colors.red,
            description: "Take one of your opponent's pawns.",
            altText: "Small victories add up quickly.",
            icon: FontAwesomeIcons.chessPawn,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              captures.shuffle();
              String move = captures.firstWhere(
                (capture) {
                  String landingSquare = Gambit.squareOf(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare)?.type;
                  return pieceBeingCaptured == chess.PieceType.PAWN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
