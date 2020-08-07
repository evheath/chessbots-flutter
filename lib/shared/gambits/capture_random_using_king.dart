import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingKing extends Gambit {
  // singleton logic so that CaptureRandomUsingKing is only created once
  static final CaptureRandomUsingKing _singleton =
      CaptureRandomUsingKing._internal();
  factory CaptureRandomUsingKing() => _singleton;

  CaptureRandomUsingKing._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKing),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question)
            ],
            demoFEN: '4k3/8/8/8/5n2/4Kb2/5p2/8 w - - 0 1',
            title: "King takes Random",
            color: Colors.red,
            description: "Capture any enemy piece with the King.",
            altText: "Quite telling how your king doesn't face me himself.",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
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
