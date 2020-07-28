import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MovePawnSafely extends Gambit {
  // singleton logic so that MoveRandomPawn is only created once
  static final MovePawnSafely _singleton = MovePawnSafely._internal();
  factory MovePawnSafely() => _singleton;

  MovePawnSafely._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.arrowRight),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '1q6/P4k2/7r/2P5/4p2b/p2P2Q1/4P3/3K1b2 w - - 0 1',
            vector: WhitePawn(),
            title: "Move Pawn, safely",
            color: Colors.grey,
            description:
                "Move a pawn to an undefended square--this can include promotions or captures.",
            altText: "No one know this land better'n us",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<chess.Move> pawnMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.PAWN)
                  .toList()
                    ..shuffle();

              chess.Move move = pawnMoves.firstWhere(
                  (pawnMove) => Gambit.safeMove(pawnMove, game),
                  orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
