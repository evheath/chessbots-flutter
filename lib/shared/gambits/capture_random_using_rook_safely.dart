import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingRookSafely extends Gambit {
  // singleton logic so that CaptureRandomUsingRookSafely is only created once
  static final CaptureRandomUsingRookSafely _singleton =
      CaptureRandomUsingRookSafely._internal();
  factory CaptureRandomUsingRookSafely() => _singleton;

  CaptureRandomUsingRookSafely._internal()
      : super(
            cost: 9,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '2r1k3/8/1n2p3/pRR1q3/5p2/Pp6/1PbBPPPP/4KBN1 w - - 0 1',
            title: "Rook takes Random, safely",
            color: Colors.red,
            description:
                "Capture any enemy piece with a rook--only if there is no threat of recapture",
            altText: "Reinforcements arrive today.",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
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
