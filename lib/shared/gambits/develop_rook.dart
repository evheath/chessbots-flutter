import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class DevelopRook extends Gambit {
  // singleton logic so that DevelopRook is only created once
  static final DevelopRook _singleton = DevelopRook._internal();
  factory DevelopRook() => _singleton;

  DevelopRook._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chartLine),
            ],
            demoFEN:
                'rnbqkbnr/ppp2ppp/4p3/3p4/7P/2N5/PPPPPPP1/R1BQKBNR w KQkq - 0 1',
            title: "Develop Rook",
            color: Colors.grey,
            description: "Move a rook from its starting position.",
            altText: "Why even call us the garrison if we're always on patrol?",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<chess.Move> rookMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.ROOK)
                  .toList()
                    ..shuffle();

              chess.Move move = rookMoves.firstWhere((rookMove) {
                // find the first Rook move that starts in a proper starting square
                List<String> acceptableStartingSquares =
                    game.turn == chess.Color.WHITE
                        ? ['a1', 'h1']
                        : ['a8', 'h8'];
                return acceptableStartingSquares
                    .contains(rookMove.fromAlgebraic);
              }, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
