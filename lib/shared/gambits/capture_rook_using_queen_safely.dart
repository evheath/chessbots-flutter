import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingQueenSafely extends Gambit {
  // singleton logic so that CaptureRookUsingQueenSafely is only created once
  static final CaptureRookUsingQueenSafely _singleton =
      CaptureRookUsingQueenSafely._internal();
  factory CaptureRookUsingQueenSafely() => _singleton;

  CaptureRookUsingQueenSafely._internal()
      : super(
            cost: 6,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                '1r2k2r/p2p1p2/1pn1p1p1/n3Q3/2b5/8/PPpBPPPP/RN2KBNR w KQ - 0 1',
            title: "Queen takes Rook, safely",
            color: Colors.red,
            description:
                "Capture an enemy rook with a queen--only if there is no threat of recapture",
            altText: "What a hideous structure.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.ROOK &&
                      move.piece == chess.PieceType.QUEEN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
