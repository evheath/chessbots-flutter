import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingBishop extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingBishop _singleton =
      CheckOpponentUsingBishop._internal();
  factory CheckOpponentUsingBishop() => _singleton;

  CheckOpponentUsingBishop._internal()
      : super(
          cost: 1,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
          ],
          demoFEN:
              "rnbq1b1r/ppp1pkp1/5n1p/4P1PP/8/B2BRN2/PP3P2/3QK2R w - - 0 1",
          title: "Bishop Check",
          color: Colors.red,
          description: "Attack your opponent's king using a bishop",
          altText: "The only eternal kingdom is the Lord's",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> bishopMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.BISHOP)
                .toList()
                  ..shuffle();

            chess.Move check = bishopMoves.firstWhere(
              (bishopMove) => game.move_to_san(bishopMove).contains("+"),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
