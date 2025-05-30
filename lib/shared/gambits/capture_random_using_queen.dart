import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingQueen extends Gambit {
  // singleton logic so that CaptureRandomUsingQueen is only created once
  static final CaptureRandomUsingQueen _singleton =
      CaptureRandomUsingQueen._internal();
  factory CaptureRandomUsingQueen() => _singleton;

  CaptureRandomUsingQueen._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question)
            ],
            demoFEN:
                'r3k2r/ppppppp1/7n/1n6/8/bQq2b2/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Random",
            color: Colors.red,
            description: "Capture any enemy piece with a queen.",
            altText: "My power doesn't seem so abstract now does it?",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.piece == chess.PieceType.QUEEN &&
                      move.captured != null)
                  .toList()
                    ..shuffle();
              chess.Move move = captures.firstWhere(
                (capture) => true,
                orElse: () => null,
              );

              return move == null ? null : game.move_to_san(move);
            }));
}
