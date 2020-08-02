import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureBishopUsingRandom extends Gambit {
  // singleton logic so that CaptureBishop is only created once
  static final CaptureBishopUsingRandom _singleton =
      CaptureBishopUsingRandom._internal();
  factory CaptureBishopUsingRandom() => _singleton;

  CaptureBishopUsingRandom._internal()
      : super(
          cost: 3,
          demoFEN:
              'r1bqk1nr/pPpppppp/1N6/3n1b2/4P3/6N1/PP1P1PPP/R1BQKB1R w KQkq - 0 1',
          vector: WhiteBishop(),
          title: "Random takes Bishop",
          color: Colors.red,
          description:
              "Take one of opponent's bishops using any available piece.",
          altText: "I wonder what you will preach about in heaven.",
          icon: FontAwesomeIcons.question,
          findMove: ((chess.Chess game) {
            List<chess.Move> captures = game
                .generate_moves()
                .where((move) => move.captured == chess.PieceType.BISHOP)
                .toList();
            captures.shuffle();

            chess.Move capture = captures.firstWhere(
              (possibleMove) => true,
              orElse: () => null,
            );

            return capture == null ? null : game.move_to_san(capture);
          }),
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
          ],
        );
}
