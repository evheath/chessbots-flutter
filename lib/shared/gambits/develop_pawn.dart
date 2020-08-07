import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class DevelopPawn extends Gambit {
  // singleton logic so that DevelopPawn is only created once
  static final DevelopPawn _singleton = DevelopPawn._internal();
  factory DevelopPawn() => _singleton;

  DevelopPawn._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chartLine),
            ],
            demoFEN:
                'rnbqkbnr/ppp2ppp/4p3/3p4/7P/2N5/PPPPPPP1/R1BQKBNR w KQkq - 0 1',
            title: "Develop Pawn",
            color: Colors.grey,
            description: "Move one of your pawns from its starting position.",
            altText: "Anywhere's better'n here.",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<chess.Move> pawnMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.PAWN)
                  .toList()
                    ..shuffle();

              chess.Move move = pawnMoves.firstWhere((pawnMove) {
                List<String> acceptableStartingSquares =
                    game.turn == chess.Color.WHITE
                        ? ['a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2']
                        : ['a7', 'b7', 'c7', 'd7', 'e7', 'f7', 'g7', 'h7'];
                return acceptableStartingSquares
                    .contains(pawnMove.fromAlgebraic);
              }, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
