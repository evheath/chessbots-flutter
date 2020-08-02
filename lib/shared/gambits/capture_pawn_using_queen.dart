import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingQueen extends Gambit {
  // singleton logic so that CapturePawnUsingQueen is only created once
  static final CapturePawnUsingQueen _singleton =
      CapturePawnUsingQueen._internal();
  factory CapturePawnUsingQueen() => _singleton;

  CapturePawnUsingQueen._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn)
            ],
            demoFEN:
                'rn2k2r/ppppppp1/8/8/8/bQq2b1n/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Pawn",
            color: Colors.red,
            description: "Capture an enemy pawn with a queen.",
            altText: "Do I even need to bury this one?",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.PAWN &&
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
