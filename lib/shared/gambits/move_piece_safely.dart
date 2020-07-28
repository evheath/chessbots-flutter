import 'package:chessbotsmobile/models/gambit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class MovePieceSafely extends Gambit {
  // singleton logic so that MovePieceSafely is only created once
  static final MovePieceSafely _singleton = MovePieceSafely._internal();
  factory MovePieceSafely() => _singleton;

  MovePieceSafely._internal()
      : super(
            cost: 5,
            demoFEN:
                'r2qk1r1/1pp1bp2/p1npbnpp/4p1B1/3PP3/N1P2N2/PPQ2PPP/R3KB1R w KQkq - 0 1',
            title: "Move Random, safely",
            color: Colors.grey,
            description: "Move a random piece to an unattacked square.",
            altText: "Discretion is the better part of valor",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> moves = game.generate_moves().toList()
                ..shuffle();

              chess.Move move = moves.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return move == null ? null : game.move_to_san(move);
            }));
}
