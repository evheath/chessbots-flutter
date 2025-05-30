import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';

import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CapturePawnUsingRandom extends Gambit {
  // singleton logic so that CapturePawn is only created once
  static final CapturePawnUsingRandom _singleton =
      CapturePawnUsingRandom._internal();
  factory CapturePawnUsingRandom() => _singleton;

  CapturePawnUsingRandom._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn)
            ],
            demoFEN:
                "rnbqkbnr/pppp1ppp/8/6N1/4p3/2P3P1/PPQPPPBP/RNB1K2R w KQkq - 0 1",
            vector: WhitePawn(),
            title: "Random takes Pawn",
            color: Colors.red,
            description: "Take a pawn using any available piece.",
            altText: "Small victories.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) => move.captured == chess.PieceType.PAWN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
