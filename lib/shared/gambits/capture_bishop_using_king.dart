import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingKing extends Gambit {
  // singleton logic so that CaptureBishopUsingKing is only created once
  static final CaptureBishopUsingKing _singleton =
      CaptureBishopUsingKing._internal();
  factory CaptureBishopUsingKing() => _singleton;

  CaptureBishopUsingKing._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKing),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
            ],
            demoFEN: '4k3/8/8/8/3q4/4Kb2/8/8 w - - 0 1',
            title: "King takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with the king.",
            altText: "I'm afraid I'm only as good as MY God",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.BISHOP &&
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
