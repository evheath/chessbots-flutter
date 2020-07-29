import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingQueen extends Gambit {
  // singleton logic so that CaptureQueenUsingQueen is only created once
  static final CaptureQueenUsingQueen _singleton =
      CaptureQueenUsingQueen._internal();
  factory CaptureQueenUsingQueen() => _singleton;

  CaptureQueenUsingQueen._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN:
                '1nb1kbn1/pppppp1p/2r3r1/8/4B3/Q2q1p2/PPPPPPPP/RNB1K1NR w KQ - 0 1',
            title: "Queen takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with your own.",
            altText: "I grew tired of waiting for your husband to do it.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> qxQCaptures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
                      move.piece == chess.PieceType.QUEEN)
                  .toList()
                    ..shuffle();

              chess.Move capture = qxQCaptures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
