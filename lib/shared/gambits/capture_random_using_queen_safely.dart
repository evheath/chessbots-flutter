import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingQueenSafely extends Gambit {
  // singleton logic so that CaptureRandomUsingQueenSafely is only created once
  static final CaptureRandomUsingQueenSafely _singleton =
      CaptureRandomUsingQueenSafely._internal();
  factory CaptureRandomUsingQueenSafely() => _singleton;

  CaptureRandomUsingQueenSafely._internal()
      : super(
            cost: 10,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r3k2r/ppppppp1/8/nn6/2b5/2Q5/PPpBPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Random, safely",
            color: Colors.red,
            description:
                "Capture any enemy piece with a queen--only if there is no threat of recapture",
            altText: "They had their chance",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
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
