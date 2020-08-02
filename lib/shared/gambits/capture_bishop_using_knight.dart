import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingKnight extends Gambit {
  // singleton logic so that CaptureBishopUsingKnight is only created once
  static final CaptureBishopUsingKnight _singleton =
      CaptureBishopUsingKnight._internal();
  factory CaptureBishopUsingKnight() => _singleton;

  CaptureBishopUsingKnight._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
            ],
            demoFEN:
                'rn2k3/ppppppp1/8/8/8/b1q2b1n/PPprPPPP/RNBQKBNR w KQq - 0 1',
            title: "Knight takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with a knight.",
            altText: "Who will hear my confession now?",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.BISHOP &&
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
