import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureRandomUsingRandom extends Gambit {
  // singleton logic so that CaptureRandomPiece is only created once
  static final CaptureRandomUsingRandom _singleton =
      CaptureRandomUsingRandom._internal();
  factory CaptureRandomUsingRandom() => _singleton;

  CaptureRandomUsingRandom._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question)
            ],
            demoFEN: "3k1n2/8/8/q4R1b/1B6/8/5p2/1K6 w - - 0 1",
            vector: BlackKing(),
            title: "Random takes Random",
            color: Colors.red,
            description: "Capture any piece using any piece.",
            altText: "Hell is empty and all the devils are here.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) => move.captured != null)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
