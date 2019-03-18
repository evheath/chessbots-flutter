import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CheckOpponent extends Gambit {
  // singleton logic so that CheckOpponent is only created once
  static final CheckOpponent _singleton = CheckOpponent._internal();
  factory CheckOpponent() => _singleton;

  CheckOpponent._internal()
      : super(
            cost: 0,
            demoFEN:
                "rnbq1b1r/ppp1pkp1/5n1p/8/8/3B4/PPP2PPP/RNBQK2R w KQkq - 0 1",
            vector: WhiteKing(),
            title: "Check Opponent",
            color: Colors.red,
            description: "Attack your opponent's king!",
            altText: "Where do you think you're going?",
            icon: FontAwesomeIcons.chessKing,
            findMove: ((chess.Chess game) {
              // print("inside check oppenent.findmove");
              List<dynamic> moves = game.moves();
              // print("moves are $moves");
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString().contains("+"),
                orElse: () => null,
              );
              // print("returning $move");
              return move;
            }));
}
