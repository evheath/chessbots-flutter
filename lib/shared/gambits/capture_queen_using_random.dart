import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureQueenUsingRandom extends Gambit {
  // singleton logic so that CaptureQueen is only created once
  static final CaptureQueenUsingRandom _singleton =
      CaptureQueenUsingRandom._internal();
  factory CaptureQueenUsingRandom() => _singleton;

  CaptureQueenUsingRandom._internal()
      : super(
            cost: 10,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN:
                "1nb1kbn1/pppppp1p/2r3r1/8/4B3/3q1p2/PPPPPPPP/RNBQK1NR w KQ - 0 1",
            vector: WhiteQueen(),
            title: "Random Takes queen",
            color: Colors.red,
            description: "Take the enemy queen using any available piece",
            altText: "Even monarchs can die like commoners",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> queenCaptures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.QUEEN)
                  .toList()
                    ..shuffle();

              chess.Move capture = queenCaptures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
