import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingRook extends Gambit {
  // singleton logic so that CaptureRandomUsingRook is only created once
  static final CaptureRandomUsingRook _singleton =
      CaptureRandomUsingRook._internal();
  factory CaptureRandomUsingRook() => _singleton;

  CaptureRandomUsingRook._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question)
            ],
            demoFEN:
                'r3k3/2qppp1p/8/8/p1R1b1Rr/2n5/PPPPPPPP/1NBQKBN1 w q - 0 1',
            title: "Rook takes Random",
            color: Colors.red,
            description: "Capture any enemy piece with a rook.",
            altText: "Draw! Loose!",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
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
