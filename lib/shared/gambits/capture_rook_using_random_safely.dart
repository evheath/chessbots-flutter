import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureRookUsingRandomSafely extends Gambit {
  // singleton logic
  static final CaptureRookUsingRandomSafely _singleton =
      CaptureRookUsingRandomSafely._internal();
  factory CaptureRookUsingRandomSafely() => _singleton;

  CaptureRookUsingRandomSafely._internal()
      : super(
            cost: 15,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                "1n2kbn1/prpppp1p/6r1/2N4P/4B3/1R1q1p2/PPPPPPP1/2BQK1NR w K - 0 1",
            vector: WhiteRook(),
            title: "Random Takes Rook, safely",
            color: Colors.red,
            description:
                "Take the enemy rook using any available piece--only if there is no threat of recapture",
            altText: "Anyone can start a fire",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> rookCaptures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.ROOK)
                  .toList()
                    ..shuffle();

              chess.Move capture = rookCaptures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
