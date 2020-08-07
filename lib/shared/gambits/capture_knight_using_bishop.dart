import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingBishop extends Gambit {
  // singleton logic so that CaptureKnightUsingBishop is only created once
  static final CaptureKnightUsingBishop _singleton =
      CaptureKnightUsingBishop._internal();
  factory CaptureKnightUsingBishop() => _singleton;

  CaptureKnightUsingBishop._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
            ],
            demoFEN:
                'rn2k2r/pQpppppp/b2bq2n/8/2B2BN1/8/PPPPPPPP/RN2K2R w KQkq - 0 1',
            title: "Bishop takes Knight",
            color: Colors.red,
            description: "Capture an enemy knight with a bishop.",
            altText: "A heretic can be tolerated. Heresy cannot.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.KNIGHT &&
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
