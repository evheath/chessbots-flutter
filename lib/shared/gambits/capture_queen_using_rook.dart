import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingRook extends Gambit {
  // singleton logic so that CaptureQueenUsingRook is only created once
  static final CaptureQueenUsingRook _singleton =
      CaptureQueenUsingRook._internal();
  factory CaptureQueenUsingRook() => _singleton;

  CaptureQueenUsingRook._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN: '4k3/2qpppp1/8/8/pbR1r1Rr/2n5/PPPPPPPP/1NBQKBN1 w - - 0 1',
            title: "Rook takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with a rook.",
            altText: "Sir, a report from one of the patrols...",
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
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
