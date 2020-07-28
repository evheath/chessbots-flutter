import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class DevelopQueen extends Gambit {
  // singleton logic so that DevelopQueen is only created once
  static final DevelopQueen _singleton = DevelopQueen._internal();
  factory DevelopQueen() => _singleton;

  DevelopQueen._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
            ],
            demoFEN:
                'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/2P1B3/PP3PPP/RN1QKBNR w KQkq - 0 1',
            title: "Develop Queen",
            color: Colors.grey,
            description: "Move your queen from her starting position.",
            altText: "So it begins.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> queenMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.QUEEN)
                  .toList()
                    ..shuffle();

              chess.Move move = queenMoves.firstWhere((queenMove) {
                // find the first Queen move that starts in a proper starting square
                List<String> acceptableStartingSquares =
                    game.turn == chess.Color.WHITE ? ['d1'] : ['d8'];
                return acceptableStartingSquares
                    .contains(queenMove.fromAlgebraic);
              }, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
