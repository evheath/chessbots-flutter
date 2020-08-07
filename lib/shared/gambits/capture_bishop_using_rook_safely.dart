import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingRookSafely extends Gambit {
  // singleton logic so that CaptureBishopUsingRookSafely is only created once
  static final CaptureBishopUsingRookSafely _singleton =
      CaptureBishopUsingRookSafely._internal();
  factory CaptureBishopUsingRookSafely() => _singleton;

  CaptureBishopUsingRookSafely._internal()
      : super(
            cost: 3,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '4k2q/p3r3/2R1p3/2b5/2R2p2/Pp6/1PbBPPPP/4KBN1 w - - 0 1',
            title: "Rook takes Bishop, safely",
            color: Colors.red,
            description:
                "Capture an enemy bishop with a rook--only if there is no threat of recapture",
            altText:
                "Let the missionaries starve out there. The gate will remain closed.",
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
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
