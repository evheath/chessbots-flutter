import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingRandomSafely extends Gambit {
  // singleton logic so that CaptureUndefendedPiece is only created once
  static final CaptureRandomUsingRandomSafely _singleton =
      CaptureRandomUsingRandomSafely._internal();
  factory CaptureRandomUsingRandomSafely() => _singleton;

  CaptureRandomUsingRandomSafely._internal()
      : super(
            cost: 10,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'rnb1k3/1p1p1ppp/pqp5/2b1p1N1/1PB5/8/PBPPPPPP/RN1QK2R w KQq - 0 1',
            title: "Random takes Random, safely",
            color: Colors.red,
            description:
                "Take any enemy piece using any piece of your own--only if there is no threat of recapture",
            altText:
                "Defend our border, lest it turn into someone else's border.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) => move.captured != null)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
