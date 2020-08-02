import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingBishop extends Gambit {
  // singleton logic so that CapturePawnUsingBishop is only created once
  static final CapturePawnUsingBishop _singleton =
      CapturePawnUsingBishop._internal();
  factory CapturePawnUsingBishop() => _singleton;

  CapturePawnUsingBishop._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn)
            ],
            demoFEN:
                'r1b1kbnr/ppppppp1/1q6/8/3B4/2n1p3/PPPPPPPP/RNBQK1NR w KQkq - 0 1',
            title: "Bishop takes Pawn",
            color: Colors.red,
            description: "Capture an enemy pawn with a bishop.",
            altText:
                "Evangelize them? As if these savages weren't dangerous enough already",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.PAWN &&
                      move.piece == chess.PieceType.BISHOP)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
