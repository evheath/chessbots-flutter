import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CastleQueenSide extends Gambit {
  // singleton logic so that CastleQueenSide is only created once
  static final CastleQueenSide _singleton = CastleQueenSide._internal();
  factory CastleQueenSide() => _singleton;

  CastleQueenSide._internal()
      : super(
            cost: 1,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKing),
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.chess),
            ],
            demoFEN:
                "r2qk2r/pbppbppp/1pn1pn2/8/2BPP3/2N1BN2/PPPQ1PPP/R3K2R w KQkq - 0 1",
            vector: WhiteRook(),
            title: "Castle, Queen-side",
            color: Colors.blue,
            description: "Move your king to safety and activate a rook!",
            altText: "A little defense goes a long way.",
            icon: FontAwesomeIcons.chess,
            findMove: ((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) => move.toString() == "O-O-O",
                orElse: () => null,
              );
              return move;
            }));
}
