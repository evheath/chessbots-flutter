import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingRookSafely extends Gambit {
  // singleton logic so that CapturePawnUsingRookSafely is only created once
  static final CapturePawnUsingRookSafely _singleton =
      CapturePawnUsingRookSafely._internal();
  factory CapturePawnUsingRookSafely() => _singleton;

  CapturePawnUsingRookSafely._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '4k2q/p3r3/4p1n1/1p2R3/5p2/2N5/PPpBPPPP/2R1KBN1 w - - 0 1',
            title: "Rook takes Pawn, safely",
            color: Colors.red,
            description:
                "Capture an enemy pawn with a rook--only if there is no threat of recapture",
            altText: "Look what we found in the moat.",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.PAWN &&
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
