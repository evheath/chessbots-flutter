import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingRandomSafely extends Gambit {
  // singleton logic
  static final CapturePawnUsingRandomSafely _singleton =
      CapturePawnUsingRandomSafely._internal();
  factory CapturePawnUsingRandomSafely() => _singleton;

  CapturePawnUsingRandomSafely._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                "r1bqk2r/ppp2ppp/2p2n2/2b1p3/4P3/1P3NQ1/PBPP1PPP/RN2K2R w KQkq - 0 1",
            title: "Random Takes Pawn, safely",
            color: Colors.red,
            description:
                "Take the enemy pawn using any available piece--only if there is no threat of recapture",
            altText:
                "The object of war is not to die for your country but to make the other poor bastard die for his.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> pawnCaptures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.PAWN)
                  .toList()
                    ..shuffle();

              chess.Move capture = pawnCaptures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
