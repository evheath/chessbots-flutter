import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingRook extends Gambit {
  // singleton logic so that CaptureRookUsingRook is only created once
  static final CaptureRookUsingRook _singleton =
      CaptureRookUsingRook._internal();
  factory CaptureRookUsingRook() => _singleton;

  CaptureRookUsingRook._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook)
            ],
            demoFEN: '4k3/2qpppp1/8/8/pbR1r1Rr/2n5/PPPPPPPP/1NBQKBN1 w - - 0 1',
            title: "Rook takes Rook",
            color: Colors.red,
            description: "Capture an enemy rook with your own.",
            altText: "I said I don't care, now load it into the trebuchet.",
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
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
