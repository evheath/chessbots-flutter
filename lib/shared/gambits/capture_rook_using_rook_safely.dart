import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingRookSafely extends Gambit {
  // singleton logic so that CaptureRookUsingRookSafely is only created once
  static final CaptureRookUsingRookSafely _singleton =
      CaptureRookUsingRookSafely._internal();
  factory CaptureRookUsingRookSafely() => _singleton;

  CaptureRookUsingRookSafely._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '2r1k2q/p7/2R1p3/2R1r3/5p2/Pp6/1PbBPPPP/4KBN1 w - - 0 1',
            title: "Rook takes Rook, safely",
            color: Colors.red,
            description:
                "Capture an enemy rook with one of your own--only if there is no threat of recapture",
            altText: "The tunnels are nearly finished my lord.",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.ROOK &&
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
