import 'package:chessbotsmobile/models/gambit_tag.dart';
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
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.yellow, icon: FontAwesomeIcons.medal),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.yellow, icon: FontAwesomeIcons.question),
            ],
            demoFEN: "2bqk2r/PP2ppbp/5n2/8/8/8/2PPPPPP/RNBQKBNR w KQk - 0 1",
            title: "Promote with capture",
            color: Colors.yellow,
            description:
                "Promote a pawn only if it can also capture a piece. Important: if the pawn can't capture, this gambit won't activate",
            altText: "The memory of the fallen outweighs these medals.",
            icon: FontAwesomeIcons.question,
            findMove: ((chess.Chess game) {
              List<chess.Move> promotions = game
                  .generate_moves()
                  .where(
                      (move) => move.promotion != null && move.captured != null)
                  .toList();
              promotions.shuffle();

              chess.Move promotion = promotions.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return promotion == null ? null : game.move_to_san(promotion);
            }));
}
