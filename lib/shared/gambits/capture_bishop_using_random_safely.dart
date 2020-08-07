import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingRandomSafely extends Gambit {
  // singleton logic
  static final CaptureBishopUsingRandomSafely _singleton =
      CaptureBishopUsingRandomSafely._internal();
  factory CaptureBishopUsingRandomSafely() => _singleton;

  CaptureBishopUsingRandomSafely._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                "r1bqk2r/ppp2ppp/2p2n2/2b1p3/1P1PP1Q1/1N3N2/PB3PPP/2R1K2R w Kkq - 0 1",
            title: "Random Takes Bishop, safely",
            color: Colors.red,
            description:
                "Take an enemy bishop using any available piece--only if there is no threat of recapture",
            altText: "Abandoned by your God and army.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> bishopCaptures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.BISHOP)
                  .toList()
                    ..shuffle();

              chess.Move capture = bishopCaptures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
