import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingRandom extends Gambit {
  // singleton logic
  static final CaptureKnightUsingRandom _singleton =
      CaptureKnightUsingRandom._internal();
  factory CaptureKnightUsingRandom() => _singleton;

  CaptureKnightUsingRandom._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
            ],
            demoFEN:
                'r1bqk1nr/pppppppp/8/3n1b2/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1',
            title: "Random takes Knight",
            color: Colors.red,
            description:
                "Take one of opponent's knights using any available piece.",
            altText: "The occupation ends today",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> pawnCaptures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.KNIGHT)
                  .toList()
                    ..shuffle();

              chess.Move capture = pawnCaptures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
