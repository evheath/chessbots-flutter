import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureRookUsingRandom extends Gambit {
  // singleton logic so that CaptureRook is only created once
  static final CaptureRookUsingRandom _singleton =
      CaptureRookUsingRandom._internal();
  factory CaptureRookUsingRandom() => _singleton;

  CaptureRookUsingRandom._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook)
            ],
            demoFEN:
                "rnbqkbn1/ppp1pppp/8/3p1r2/4P3/4N3/PPPP1PPP/RNBQKB1R w KQkq - 0 1",
            vector: WhiteRook(),
            title: "Random takes Rook",
            color: Colors.red,
            description:
                "Capture one of opponent's rooks using any available piece.",
            altText: "It didn't even take twenty men...",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.ROOK)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
