import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToKnight extends Gambit {
  // singleton logic so that PromotePawnToKnight is only created once
  static final PromotePawnToKnight _singleton = PromotePawnToKnight._internal();
  factory PromotePawnToKnight() => _singleton;

  PromotePawnToKnight._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.yellow, icon: FontAwesomeIcons.medal),
              GambitTag(
                  color: Colors.yellow, icon: FontAwesomeIcons.chessKnight),
            ],
            demoFEN: "r1bqk2r/pP2ppbp/5n2/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1",
            vector: WhiteKnight(),
            title: "Promote to knight",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a knight",
            altText:
                "The clergy has no place for a woman--but plently of places to stick a sword.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> promotions = game
                  .generate_moves()
                  .where((move) => move.promotion == chess.PieceType.KNIGHT)
                  .toList();
              promotions.shuffle();

              chess.Move promotion = promotions.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return promotion == null ? null : game.move_to_san(promotion);
            }));
}
