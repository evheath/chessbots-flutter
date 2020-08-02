import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureKnightUsingRook extends Gambit {
  // singleton logic so that CaptureKnightUsingRook is only created once
  static final CaptureKnightUsingRook _singleton =
      CaptureKnightUsingRook._internal();
  factory CaptureKnightUsingRook() => _singleton;

  CaptureKnightUsingRook._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKnight),
            ],
            demoFEN: '4k3/2qpppp1/8/8/pbR1r2r/nRn5/PPPPPPPP/1NBQKBN1 w - - 0 1',
            title: "Rook takes Knight",
            color: Colors.red,
            description: "Capture an enemy knight with a rook.",
            altText: "Ready the oil!",
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
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
