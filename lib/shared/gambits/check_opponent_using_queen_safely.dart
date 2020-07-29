import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingQueenSafely extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingQueenSafely _singleton =
      CheckOpponentUsingQueenSafely._internal();
  factory CheckOpponentUsingQueenSafely() => _singleton;

  CheckOpponentUsingQueenSafely._internal()
      : super(
          cost: 5,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
            GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
          ],
          demoFEN: "rnbq1b1r/pppRpkp1/5n1p/4P1PP/8/B7/PP2NP2/3QK3 w - - 0 1",
          title: "Safe Queen Check",
          color: Colors.red,
          description:
              "Attack your opponent's king using a queen--only if there is no threat of recapture",
          altText: "The choice is yours: a swivel or a mantel",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> queenMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.QUEEN)
                .toList()
                  ..shuffle();

            chess.Move check = queenMoves.firstWhere(
              (queenMove) =>
                  game.move_to_san(queenMove).contains("+") &&
                  Gambit.safeMove(queenMove, game),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
