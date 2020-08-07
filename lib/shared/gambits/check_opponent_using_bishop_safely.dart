import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingBishopSafely extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingBishopSafely _singleton =
      CheckOpponentUsingBishopSafely._internal();
  factory CheckOpponentUsingBishopSafely() => _singleton;

  CheckOpponentUsingBishopSafely._internal()
      : super(
          cost: 4,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
            GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
          ],
          demoFEN:
              "rnbq1b1r/ppp1pkp1/1n5p/4P1PP/8/B2BRN2/PP3P2/3QK2R w - - 0 1",
          title: "Safe Bishop Check",
          color: Colors.red,
          description:
              "Attack your opponent's king using a bishop--only if there is no threat of recapture",
          altText: "If you must pursue the wicked, do not follow their path",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> bishopMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.BISHOP)
                .toList()
                  ..shuffle();

            chess.Move check = bishopMoves.firstWhere(
              (bishopMove) =>
                  game.move_to_san(bishopMove).contains("+") &&
                  Gambit.safeMove(bishopMove, game),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
