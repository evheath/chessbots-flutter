import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureRandomUsingKnight extends Gambit {
  // singleton logic so that CaptureRandomUsingKnight is only created once
  static final CaptureRandomUsingKnight _singleton =
      CaptureRandomUsingKnight._internal();
  factory CaptureRandomUsingKnight() => _singleton;

  CaptureRandomUsingKnight._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessKnight),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.question)
            ],
            demoFEN:
                'rnbqk2r/p1pp1ppp/1p3n2/4p3/4P3/bP3N2/PBPP1PPP/RN1QKB1R w KQkq - 0 1',
            title: "Knight takes Random",
            color: Colors.red,
            description: "Take a random piece using one of your knights.",
            altText: "Deus Vult.",
            icon: FontAwesomeIcons.chessKnight,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured != null &&
                      move.piece == chess.PieceType.KNIGHT)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
