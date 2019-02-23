import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureBishop extends Gambit {
  // singleton logic so that CaptureBishop is only created once
  static final CaptureBishop _singleton = CaptureBishop._internal();
  factory CaptureBishop() => _singleton;

  CaptureBishop._internal()
      : super(
            demoFEN:
                'r1bqk1nr/pppppppp/8/3n1b2/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
            vector: WhiteBishop(),
            title: "Capture bishop",
            color: Colors.red,
            description: "Take one of opponent's bishops.",
            altText: "Now we're talking.",
            icon: FontAwesomeIcons.chessBishop,
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
                  return pieceBeingCaptured == chess.PieceType.BISHOP;
                },
                orElse: () => null,
              );
              return move;
            }));
}
