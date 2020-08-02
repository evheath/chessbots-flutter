import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToRandom extends Gambit {
  // singleton logic so that PromotePawnToRandom is only created once
  static final PromotePawnToRandom _singleton = PromotePawnToRandom._internal();
  factory PromotePawnToRandom() => _singleton;

  PromotePawnToRandom._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.yellow, icon: FontAwesomeIcons.medal),
              GambitTag(color: Colors.yellow, icon: FontAwesomeIcons.question),
            ],
            demoFEN: "r1bqk2r/pP2ppbp/5n2/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1",
            vector: BlackKing(),
            title: "Promote to random",
            color: Colors.yellow,
            description:
                "If a pawn reaches the back rank, it will promote to a knight, bishop, rook or queen!",
            altText: "Feeling lucky?",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> promotions = game
                  .generate_moves()
                  .where((move) => move.promotion != null)
                  .toList();
              promotions.shuffle();

              chess.Move promotion = promotions.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return promotion == null ? null : game.move_to_san(promotion);
            }));
}
