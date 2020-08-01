import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingRookSafely extends Gambit {
  // singleton logic so that CaptureKnightUsingRookSafely is only created once
  static final CaptureKnightUsingRookSafely _singleton =
      CaptureKnightUsingRookSafely._internal();
  factory CaptureKnightUsingRookSafely() => _singleton;

  CaptureKnightUsingRookSafely._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '4k2q/p3r3/4p3/1p2R1n1/5p2/2N5/PPpBPPPP/2RnKBN1 w - - 0 1',
            title: "Rook takes Knight, safely",
            color: Colors.red,
            description:
                "Capture an enemy knight with a rook--only if there is no threat of recapture",
            altText:
                "Do not fire the ballista until they charge directly at us.",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.KNIGHT &&
                      move.piece == chess.PieceType.ROOK)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
