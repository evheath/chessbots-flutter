import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MovePawn extends Gambit {
  // singleton logic so that MoveRandomPawn is only created once
  static final MovePawn _singleton = MovePawn._internal();
  factory MovePawn() => _singleton;

  MovePawn._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.arrowRight),
            ],
            demoFEN:
                "r4r2/1bn1Np1k/4p1pp/pPpn4/P1N5/6P1/1Q2PPBP/R4RK1 w - - 0 21",
            vector: WhitePawn(),
            title: "Move Pawn",
            color: Colors.grey,
            description: "Make a random pawn move--including captures.",
            altText: "They can't stop us all",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<chess.Move> pawnMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.PAWN)
                  .toList()
                    ..shuffle();

              chess.Move move =
                  pawnMoves.firstWhere((pawnMove) => true, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
