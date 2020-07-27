import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureKnight extends Gambit {
  // singleton logic so that CaptureKnight is only created once
  static final CaptureKnight _singleton = CaptureKnight._internal();
  factory CaptureKnight() => _singleton;

  CaptureKnight._internal()
      : super(
            cost: 3,
            demoFEN:
                'r1bqk1nr/pppppppp/8/3n1b2/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
            vector: WhiteKnight(),
            title: "Random takes Knight",
            color: Colors.red,
            description:
                "Take one of opponent's knights using any available piece.",
            altText:
                "The object of war is not to die for your country but to make the other bastard die for his.",
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
                  return pieceBeingCaptured == chess.PieceType.KNIGHT;
                },
                orElse: () => null,
              );
              return move;
            }));
}
