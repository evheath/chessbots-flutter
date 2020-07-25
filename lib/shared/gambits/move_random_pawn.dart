import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveRandomPawn extends Gambit {
  // singleton logic so that MoveRandomPawn is only created once
  static final MoveRandomPawn _singleton = MoveRandomPawn._internal();
  factory MoveRandomPawn() => _singleton;

  MoveRandomPawn._internal()
      : super(
            cost: 5,
            vector: WhitePawn(),
            title: "Random pawn move",
            color: Colors.grey,
            description: "Make a random pawn move, including captures!",
            altText: "March, march, march!",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<dynamic> moves = game.moves();
              moves.shuffle();
              String move = moves.firstWhere(
                (move) =>
                    move.toString()[0] != move.toString()[0].toUpperCase(),
                orElse: () => null,
              );
              return move;
            }));
}
