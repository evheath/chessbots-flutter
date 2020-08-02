import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRookUsingKing extends Gambit {
  // singleton logic so that CaptureRookUsingKing is only created once
  static final CaptureRookUsingKing _singleton =
      CaptureRookUsingKing._internal();
  factory CaptureRookUsingKing() => _singleton;

  CaptureRookUsingKing._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKing),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessRook)
            ],
            demoFEN: 'rnb1kbn1/pppp1ppp/8/8/8/2q5/PPPPpr2/RNBQK1N1 w Qq - 0 1',
            title: "King takes Rook",
            color: Colors.red,
            description: "Capture an enemy rook with the king.",
            altText: "I've seen more castles fall than men grow old.",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.ROOK &&
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
