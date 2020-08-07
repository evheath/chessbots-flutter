import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingKnightSafely extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingKnightSafely _singleton =
      CheckOpponentUsingKnightSafely._internal();
  factory CheckOpponentUsingKnightSafely() => _singleton;

  CheckOpponentUsingKnightSafely._internal()
      : super(
          cost: 4,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
            GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
          ],
          demoFEN:
              "rnbq1b1r/ppp1pkp1/5n1p/7P/2N5/B2BRN2/PP2PPP1/3QK2R w - - 0 1",
          title: "Safe Knight Check",
          color: Colors.red,
          description:
              "Attack your opponent's king using a knight--only if there is no threat of recapture",
          altText: "Pursue, but only within reason",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> knightMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.KNIGHT)
                .toList()
                  ..shuffle();

            chess.Move check = knightMoves.firstWhere(
              (knightMove) =>
                  game.move_to_san(knightMove).contains("+") &&
                  Gambit.safeMove(knightMove, game),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
