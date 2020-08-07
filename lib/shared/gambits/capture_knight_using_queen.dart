import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingQueen extends Gambit {
  // singleton logic so that CaptureKnightUsingQueen is only created once
  static final CaptureKnightUsingQueen _singleton =
      CaptureKnightUsingQueen._internal();
  factory CaptureKnightUsingQueen() => _singleton;

  CaptureKnightUsingQueen._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
            ],
            demoFEN:
                'r3k2r/ppppppp1/8/1n1n4/8/bQq2b2/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Knight",
            color: Colors.red,
            description: "Capture an enemy Knight with a queen.",
            altText: "I was worried I drank the poison.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.KNIGHT &&
                      move.piece == chess.PieceType.QUEEN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
