import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CheckOpponentUsingRandom extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingRandom _singleton =
      CheckOpponentUsingRandom._internal();
  factory CheckOpponentUsingRandom() => _singleton;

  CheckOpponentUsingRandom._internal()
      : super(
          cost: 0,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
          ],
          demoFEN: "rnbq1b1r/ppp1pkp1/5n1p/8/8/B2BRN2/PP3PPP/3QK2R w - - 0 1",
          vector: WhiteKing(),
          title: "Check Opponent",
          color: Colors.red,
          description: "Attack your opponent's king using any means necessary",
          altText: "That's him!",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> moves = game.generate_moves().toList()..shuffle();

            chess.Move check = moves.firstWhere(
              (oneMove) => game.move_to_san(oneMove).contains("+"),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
