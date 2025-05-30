import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToQueen extends Gambit {
  // singleton logic so that PromotePawnToQueen is only created once
  static final PromotePawnToQueen _singleton = PromotePawnToQueen._internal();
  factory PromotePawnToQueen() => _singleton;

  PromotePawnToQueen._internal()
      : super(
            cost: 30,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.yellow, icon: FontAwesomeIcons.medal),
              GambitTag(
                  color: Colors.yellow, icon: FontAwesomeIcons.chessQueen),
            ],
            demoFEN: "r1bqk2r/pP2ppbp/5n2/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1",
            vector: WhiteQueen(),
            title: "Promote to queen",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a queen",
            altText: "The best revenge for a hard life is forgetting about it.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> promotions = game
                  .generate_moves()
                  .where((move) => move.promotion == chess.PieceType.QUEEN)
                  .toList();
              promotions.shuffle();

              chess.Move promotion = promotions.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return promotion == null ? null : game.move_to_san(promotion);
            }));
}
