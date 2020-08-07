import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingRookSafely extends Gambit {
  // singleton logic so that CaptureQueenUsingRookSafely is only created once
  static final CaptureQueenUsingRookSafely _singleton =
      CaptureQueenUsingRookSafely._internal();
  factory CaptureQueenUsingRookSafely() => _singleton;

  CaptureQueenUsingRookSafely._internal()
      : super(
            cost: 8,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '2rrk3/8/4p3/pRR1q3/5p2/Pp6/1PbBPPPP/4KBN1 w - - 0 1',
            title: "Rook takes Queen, safely",
            color: Colors.red,
            description:
                "Capture an enemy queen with a rook--only if there is no threat of recapture",
            altText: "Captain, the royal escort's is within firing distance!",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
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
