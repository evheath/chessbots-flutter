import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveKnight extends Gambit {
  // singleton logic so that MoveRandomKnight is only created once
  static final MoveKnight _singleton = MoveKnight._internal();
  factory MoveKnight() => _singleton;

  MoveKnight._internal()
      : super(
            cost: 1,
            demoFEN:
                'r1bqkb1r/ppp2ppp/2n5/3np1N1/2B5/8/PPPP1PPP/RNBQK2R w KQkq - 0 1',
            vector: WhiteKnight(),
            title: "Move Knight",
            color: Colors.grey,
            description: "Make a random knight move--including captures.",
            altText: "Check the map again",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> knightMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.KNIGHT)
                  .toList()
                    ..shuffle();

              chess.Move move = knightMoves.firstWhere((knightMove) => true,
                  orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
