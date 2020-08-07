import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingBishopSafely extends Gambit {
  // singleton logic so that CaptureRookUsingBishopSafely is only created once
  static final CaptureRookUsingBishopSafely _singleton =
      CaptureRookUsingBishopSafely._internal();
  factory CaptureRookUsingBishopSafely() => _singleton;

  CaptureRookUsingBishopSafely._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                '1nb1kbn1/ppppp3/6r1/3r4/4B3/5q2/PPPPPPPP/RNBQK1NR w KQ - 0 1',
            title: "Bishop takes Rook, safely",
            color: Colors.red,
            description:
                "Capture an enemy rook with a bishop--only if there is no threat of recapture",
            altText: "One more lap around these walls makes seven.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.ROOK &&
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
