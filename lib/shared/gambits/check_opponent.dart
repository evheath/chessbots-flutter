import 'package:chessbotsmobile/models/gambit_tag.dart';
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
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.question),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.plus),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessKing),
            ],
            demoFEN:
                "rnbq1b1r/ppp1pkp1/5n1p/8/8/3B1N2/PPP2PPP/R1BQK2R w KQ - 0 1",
            vector: WhiteKing(),
            title: "Check Opponent",
            color: Colors.red,
            description:
                "Attack your opponent's king using any means necessary",
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
