import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingKnight extends Gambit {
  // singleton logic so that CaptureRookUsingKnight is only created once
  static final CaptureRookUsingKnight _singleton =
      CaptureRookUsingKnight._internal();
  factory CaptureRookUsingKnight() => _singleton;

  CaptureRookUsingKnight._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook)
            ],
            demoFEN:
                'rn2k3/ppppppp1/8/8/8/b1q2b1n/PPprPPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Rook",
            color: Colors.red,
            description: "Capture an enemy Rook with a knight.",
            altText: "Fixed fortifications are monuments to stupidity.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.ROOK &&
                      move.piece == chess.PieceType.KNIGHT)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
