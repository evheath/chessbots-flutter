import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingQueen extends Gambit {
  // singleton logic so that CaptureBishopUsingQueen is only created once
  static final CaptureBishopUsingQueen _singleton =
      CaptureBishopUsingQueen._internal();
  factory CaptureBishopUsingQueen() => _singleton;

  CaptureBishopUsingQueen._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
            ],
            demoFEN:
                'rn2k2r/ppppppp1/8/8/8/bQq2b1n/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with a queen.",
            altText: "There's no stopping a rumor, only changing it.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.BISHOP &&
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
