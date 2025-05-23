import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingBishop extends Gambit {
  // singleton logic so that CaptureQueenUsingBishop is only created once
  static final CaptureQueenUsingBishop _singleton =
      CaptureQueenUsingBishop._internal();
  factory CaptureQueenUsingBishop() => _singleton;

  CaptureQueenUsingBishop._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN:
                '1nb1kbn1/pppppp1p/2r5/8/4B3/3q1r2/PPPPPPPP/RNBQK1NR w KQ - 0 1',
            title: "Bishop takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with a bishop.",
            altText: "God save the queen, for I will not.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
                      move.piece == chess.PieceType.BISHOP)
                  .toList()
                    ..shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
