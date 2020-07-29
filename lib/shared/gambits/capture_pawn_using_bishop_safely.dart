import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingBishopSafely extends Gambit {
  // singleton logic so that CapturePawnUsingBishopSafely is only created once
  static final CapturePawnUsingBishopSafely _singleton =
      CapturePawnUsingBishopSafely._internal();
  factory CapturePawnUsingBishopSafely() => _singleton;

  CapturePawnUsingBishopSafely._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r1b1kbnr/pp1pppp1/1q6/8/3B4/2p1p3/PPPPP1PP/RNBQK1NR w KQkq - 0 1',
            title: "Bishop takes Pawn, safely",
            color: Colors.red,
            description:
                "Capture an enemy pawn with a bishop--only if there is no threat of recapture.",
            altText: "May the Lord shepard the misguided.",
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
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
