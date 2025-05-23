import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class DevelopBishop extends Gambit {
  // singleton logic so that DevelopBishop is only created once
  static final DevelopBishop _singleton = DevelopBishop._internal();
  factory DevelopBishop() => _singleton;

  DevelopBishop._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chartLine),
            ],
            demoFEN:
                'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPP2PPP/RNBQKB1R w KQkq - 0 1',
            title: "Develop Bishop",
            color: Colors.grey,
            description: "Move a bishop from its starting position.",
            altText: "God works in mysterious ways. We do not.",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> bishopMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.BISHOP)
                  .toList()
                    ..shuffle();

              chess.Move move = bishopMoves.firstWhere((bishopMove) {
                // find the first Bishop move that starts in a proper starting square
                List<String> acceptableStartingSquares =
                    game.turn == chess.Color.WHITE
                        ? ['c1', 'f1']
                        : ['c8', 'f8'];
                return acceptableStartingSquares
                    .contains(bishopMove.fromAlgebraic);
              }, orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
