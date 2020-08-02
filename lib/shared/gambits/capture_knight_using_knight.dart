import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingKnight extends Gambit {
  // singleton logic so that CaptureKnightUsingKnight is only created once
  static final CaptureKnightUsingKnight _singleton =
      CaptureKnightUsingKnight._internal();
  factory CaptureKnightUsingKnight() => _singleton;

  CaptureKnightUsingKnight._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
            ],
            demoFEN:
                'rn2k3/ppp1ppp1/8/8/8/b1q2b1n/PPprpPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Knight",
            color: Colors.red,
            description: "Capture an enemy knight with a knight.",
            altText: "Chivarly may be dead, but now it has company",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.KNIGHT &&
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
