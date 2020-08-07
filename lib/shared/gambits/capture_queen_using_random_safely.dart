import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureQueenUsingRandomSafely extends Gambit {
  // singleton logic
  static final CaptureQueenUsingRandomSafely _singleton =
      CaptureQueenUsingRandomSafely._internal();
  factory CaptureQueenUsingRandomSafely() => _singleton;

  CaptureQueenUsingRandomSafely._internal()
      : super(
            cost: 20,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                "1nb1kbn1/pppppp1p/2r3r1/8/4B3/3q1p2/PPPPPPPP/RNBQK1NR w KQ - 0 1",
            vector: WhiteQueen(),
            title: "Random Takes queen",
            color: Colors.red,
            description:
                "Take the enemy queen using any available piece--only if there is no threat of recapture",
            altText:
                "No reason to spring the first ambush when we have so many setup",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> queenCaptures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.QUEEN)
                  .toList()
                    ..shuffle();

              chess.Move capture = queenCaptures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
