import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingPawnSafely extends Gambit {
  // singleton logic
  static final CaptureRandomUsingPawnSafely _singleton =
      CaptureRandomUsingPawnSafely._internal();
  factory CaptureRandomUsingPawnSafely() => _singleton;

  CaptureRandomUsingPawnSafely._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                '1nb1k3/prppppPp/P4P2/3Q4/2q1rRn1/3P1P2/2P1PNP1/1NB1KB1R w K - 0 1',
            title: "Pawn takes Random, safely",
            color: Colors.red,
            description:
                "Capture any enemy piece with a pawn--only if there is no threat of recapture",
            altText:
                "Becareful that the shadows don't reach out and touch you.",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
                      move.piece == chess.PieceType.PAWN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
