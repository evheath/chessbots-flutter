import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingKing extends Gambit {
  // singleton logic so that CaptureQueenUsingKing is only created once
  static final CaptureQueenUsingKing _singleton =
      CaptureQueenUsingKing._internal();
  factory CaptureQueenUsingKing() => _singleton;

  CaptureQueenUsingKing._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKing),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN: 'rnb1kbn1/pppp1ppp/8/8/8/1r6/PPPqp3/RNBQK1N1 w Qq - 0 1',
            title: "King takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with the king.",
            altText:
                "One kingdom wasn't enough for you, now six feet of dirt shall suffice.",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
                      move.piece == chess.PieceType.KING)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
