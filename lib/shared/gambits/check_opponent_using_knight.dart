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
          cost: 0,
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
            List<chess.Move> moves = game.generate_moves().toList()..shuffle();

            chess.Move check = moves.firstWhere(
              (oneMove) =>
                  oneMove.piece == chess.PieceType.KNIGHT &&
                  game.move_to_san(oneMove).contains("+"),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
