import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingPawnSafely extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingPawnSafely _singleton =
      CheckOpponentUsingPawnSafely._internal();
  factory CheckOpponentUsingPawnSafely() => _singleton;

  CheckOpponentUsingPawnSafely._internal()
      : super(
          cost: 3,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
            GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
          ],
          demoFEN:
              "rnbq1b1r/pppRpkp1/5n1p/4P1PP/8/B2B1R2/PP2NP2/3QK3 w - - 0 1",
          title: "Safe Pawn Check",
          color: Colors.red,
          description: "Safely attack your opponent's king using a pawn",
          altText: "Careful for booby traps",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> pawnMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.PAWN)
                .toList()
                  ..shuffle();

            chess.Move check = pawnMoves.firstWhere(
              (pawnMove) =>
                  game.move_to_san(pawnMove).contains("+") &&
                  Gambit.safeMove(pawnMove, game),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
