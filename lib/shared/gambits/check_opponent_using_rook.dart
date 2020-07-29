import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingRook extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingRook _singleton =
      CheckOpponentUsingRook._internal();
  factory CheckOpponentUsingRook() => _singleton;

  CheckOpponentUsingRook._internal()
      : super(
          cost: 1,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
          ],
          demoFEN:
              "rnbq1b1r/pppRpkp1/5n1p/4P1PP/8/B2B1R2/PP2NP2/3QK3 w - - 0 1",
          title: "Rook Check",
          color: Colors.red,
          description: "Attack your opponent's king using a rook",
          altText: "No thrones in the graveyard",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> rookMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.ROOK)
                .toList()
                  ..shuffle();

            chess.Move check = rookMoves.firstWhere(
              (rookMove) => game.move_to_san(rookMove).contains("+"),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
