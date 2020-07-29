import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingBishopSafely extends Gambit {
  // singleton logic so that CaptureKnightUsingBishopSafely is only created once
  static final CaptureKnightUsingBishopSafely _singleton =
      CaptureKnightUsingBishopSafely._internal();
  factory CaptureKnightUsingBishopSafely() => _singleton;

  CaptureKnightUsingBishopSafely._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r3k2r/pQpppppp/b2bq3/3n2n1/2B2BN1/8/PPPPPPPP/RN2K2R w KQkq - 0 1',
            title: "Bishop takes Knight, safely",
            color: Colors.red,
            description:
                "Capture an enemy knight with a bishop--only if there is no threat of recapture",
            altText: "It's incredible how much you can see from a steeple",
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
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
