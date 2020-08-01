import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingQueenSafely extends Gambit {
  // singleton logic so that CaptureBishopUsingQueenSafely is only created once
  static final CaptureBishopUsingQueenSafely _singleton =
      CaptureBishopUsingQueenSafely._internal();
  factory CaptureBishopUsingQueenSafely() => _singleton;

  CaptureBishopUsingQueenSafely._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                '1r2k2q/p2p1p2/1p2p1p1/nb2Q3/8/8/PPpBPPPP/RN2KBNR w KQ - 0 1',
            title: "Queen takes Bishop, safely",
            color: Colors.red,
            description:
                "Capture an enemy Bishop with a queen--only if there is no threat of recapture",
            altText: "What a magnificent cathedral...I now have.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.BISHOP &&
                      move.piece == chess.PieceType.QUEEN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
