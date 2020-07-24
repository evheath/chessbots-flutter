import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckmateOpponent extends Gambit {
  // singleton logic so that CheckmateOpponent is only created once
  static final CheckmateOpponent _singleton = CheckmateOpponent._internal();
  factory CheckmateOpponent() => _singleton;

  CheckmateOpponent._internal()
      : super(
            cost: 0,
            demoFEN:
                "r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1",
            vector: WhiteKing(),
            title: "Checkmate Opponent",
            color: Colors.orange,
            description:
                "Win the game by ensuring the capture of the opponent's King",
            altText: "Victory is ours!",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("#"),
                orElse: () => null,
              );
              return move;
            }));
}
