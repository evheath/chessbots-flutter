import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class PromoteWithCapture extends Gambit {
  // singleton logic so that PromoteWithCapture is only created once
  static final PromoteWithCapture _singleton = PromoteWithCapture._internal();
  factory PromoteWithCapture() => _singleton;

  PromoteWithCapture._internal()
      : super(
            cost: 5,
            demoFEN:
                "2bqkbnr/PPpppppp/1rn5/8/8/8/PP2PPPP/RNBQKBNR w KQkq - 0 1",
            title: "Promote with capture",
            color: Colors.yellow,
            description:
                "Promote a pawn only if it can also capture a piece. Important: if the pawn can't capture, this gambit won't activate",
            altText: "The memory of the fallen outweighs these medals.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              captures.shuffle();

              String move = captures.firstWhere(
                (move) => move.toString().contains('='),
                orElse: () => null,
              );
              return move;
            }));
}
