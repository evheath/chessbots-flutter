import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingKnight extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingKnight _singleton =
      CheckOpponentUsingKnight._internal();
  factory CheckOpponentUsingKnight() => _singleton;

  CheckOpponentUsingKnight._internal()
      : super(
          cost: 1,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
          ],
          demoFEN:
              "rnbq1b1r/ppp1pkp1/5n1p/4P1PP/2N5/B2BR3/PP3P2/3QK2R w - - 0 1",
          title: "Knight Check",
          color: Colors.red,
          description: "Attack your opponent's king using a knight",
          altText: "Press the attack!",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> knightMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.KNIGHT)
                .toList()
                  ..shuffle();

            chess.Move check = knightMoves.firstWhere(
              (knightMove) => game.move_to_san(knightMove).contains("+"),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
