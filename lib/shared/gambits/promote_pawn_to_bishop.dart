import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToBishop extends Gambit {
  // singleton logic so that PromotePawnToBishop is only created once
  static final PromotePawnToBishop _singleton = PromotePawnToBishop._internal();
  factory PromotePawnToBishop() => _singleton;

  PromotePawnToBishop._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.yellow, icon: FontAwesomeIcons.medal),
              GambitTag(
                  color: Colors.yellow, icon: FontAwesomeIcons.chessBishop),
            ],
            demoFEN: "r1bqk2r/pP2ppbp/5n2/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1",
            vector: WhiteBishop(),
            title: "Promote to bishop",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a bishop",
            altText: "Eternal God, please bless our priests...",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> promotions = game
                  .generate_moves()
                  .where((move) => move.promotion == chess.PieceType.BISHOP)
                  .toList();
              promotions.shuffle();

              chess.Move promotion = promotions.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return promotion == null ? null : game.move_to_san(promotion);
            }));
}
