import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class MoveBishop extends Gambit {
  // singleton logic so that MoveRandomBishop is only created once
  static final MoveBishop _singleton = MoveBishop._internal();
  factory MoveBishop() => _singleton;

  MoveBishop._internal()
      : super(
            cost: 2,
            demoFEN:
                'r1bqkb1r/ppp2ppp/8/3np1N1/2Bn4/8/PPP2PPP/RNBQK2R w KQkq - 0 1',
            vector: WhiteBishop(),
            title: "Move Bishop",
            color: Colors.grey,
            description: "Make a random bishop move--including captures.",
            altText: "Trust the path of God",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> bishopMoves = game
                  .generate_moves()
                  .where((oneMove) => oneMove.piece == chess.PieceType.BISHOP)
                  .toList()
                    ..shuffle();

              chess.Move move = bishopMoves.firstWhere((bishopMove) => true,
                  orElse: () => null);

              return move == null ? null : game.move_to_san(move);
            }));
}
