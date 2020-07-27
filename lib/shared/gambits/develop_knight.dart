import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class DevelopKnight extends Gambit {
  // singleton logic so that DevelopKnight is only created once
  static final DevelopKnight _singleton = DevelopKnight._internal();
  factory DevelopKnight() => _singleton;

  DevelopKnight._internal()
      : super(
            cost: 1,
            demoFEN:
                'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPP2PPP/RNBQKB1R w KQkq - 0 1',
            title: "Develop Knight",
            color: Colors.grey,
            description: "Move a knight from its starting position.",
            altText: "Activate the reserves!",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> knightMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.KNIGHT)
                  .toList()
                    ..shuffle();

              chess.Move move = knightMoves.firstWhere((knightMove) {
                // find the first knight move that starts in a proper starting square
                // e.g. a black knight that doesn't come from b8 or g8 would be invalid
                List<String> acceptableStartingSquares =
                    game.turn == chess.Color.WHITE
                        ? ['b1', 'g1']
                        : ['b8', 'g8'];
                return acceptableStartingSquares
                    .contains(knightMove.fromAlgebraic);
              }, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
