import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CheckOpponentUsingRandomSafely extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingRandomSafely _singleton =
      CheckOpponentUsingRandomSafely._internal();
  factory CheckOpponentUsingRandomSafely() => _singleton;

  CheckOpponentUsingRandomSafely._internal()
      : super(
          cost: 5,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
            GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
          ],
          demoFEN: "rnbq1b1r/ppp1pkp1/5n1p/8/8/B2BRN2/PP3PPP/3QK2R w - - 0 1",
          vector: WhiteKing(),
          title: "Safe Random Check",
          color: Colors.red,
          description:
              "Attack your opponent's king with any piece so long as it cannot result in recapture",
          altText: "Keep your distance",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> moves = game.generate_moves().toList()..shuffle();

            chess.Move check = moves.firstWhere(
              (oneMove) =>
                  game.move_to_san(oneMove).contains("+") &&
                  Gambit.safeMove(oneMove, game),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
