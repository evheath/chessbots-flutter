import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingBishopSafely extends Gambit {
  // singleton logic so that CaptureRandomUsingBishopSafely is only created once
  static final CaptureRandomUsingBishopSafely _singleton =
      CaptureRandomUsingBishopSafely._internal();
  factory CaptureRandomUsingBishopSafely() => _singleton;

  CaptureRandomUsingBishopSafely._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r1bqk2r/p1pp1ppp/1pn2n2/4p3/4P3/bP3N2/PBPP1PPP/RN1QKB1R w KQkq - 0 1',
            title: "Bishop takes Random, safely",
            color: Colors.red,
            description:
                "Take a random piece using one of your bishops--only if there is no threat of recapture",
            altText: "Blessed are the undefended...",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
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
