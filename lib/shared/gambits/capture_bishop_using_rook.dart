import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingRook extends Gambit {
  // singleton logic so that CaptureBishopUsingRook is only created once
  static final CaptureBishopUsingRook _singleton =
      CaptureBishopUsingRook._internal();
  factory CaptureBishopUsingRook() => _singleton;

  CaptureBishopUsingRook._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
            ],
            demoFEN: '4k3/2qpppp1/8/8/pbR1r2r/nRn5/PPPPPPPP/1NBQKBN1 w - - 0 1',
            title: "Rook takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with a rook.",
            altText: "Throw him from the battlements!",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.BISHOP &&
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
