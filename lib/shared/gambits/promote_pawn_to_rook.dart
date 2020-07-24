import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class PromotePawnToRook extends Gambit {
  // singleton logic so that PromotePawnToRook is only created once
  static final PromotePawnToRook _singleton = PromotePawnToRook._internal();
  factory PromotePawnToRook() => _singleton;

  PromotePawnToRook._internal()
      : super(
            cost: 10,
            demoFEN: "rnbqk2r/pP2ppbp/5n2/8/8/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1",
            vector: WhiteRook(),
            title: "Promote to rook",
            color: Colors.yellow,
            description:
                "If a pawn can reach the back rank, it will promote to a rook",
            altText: "Better to lay the bricks than die for them.",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("=R"),
                orElse: () => null,
              );
              return move;
            }));
}
