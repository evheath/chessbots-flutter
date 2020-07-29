import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CheckOpponentUsingRookSafely extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponentUsingRookSafely _singleton =
      CheckOpponentUsingRookSafely._internal();
  factory CheckOpponentUsingRookSafely() => _singleton;

  CheckOpponentUsingRookSafely._internal()
      : super(
          cost: 5,
          tags: [
            GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
            GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
            GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
          ],
          demoFEN: "4b3/5k2/8/3R4/8/6p1/1R6/4K3 w - - 0 1",
          title: "Safe Rook Check",
          color: Colors.red,
          description:
              "Attack your opponent's king using a rook--only if there is no threat of recapture",
          altText: "Send the garrison, but do not over extend, captain.",
          icon: FontAwesomeIcons.chessKing,
          findMove: ((chess.Chess game) {
            List<chess.Move> rookMoves = game
                .generate_moves()
                .where((move) => move.piece == chess.PieceType.ROOK)
                .toList()
                  ..shuffle();

            chess.Move check = rookMoves.firstWhere(
              (rookMove) =>
                  game.move_to_san(rookMove).contains("+") &&
                  Gambit.safeMove(rookMove, game),
              orElse: () => null,
            );

            return check == null ? null : game.move_to_san(check);
          }),
        );
}
