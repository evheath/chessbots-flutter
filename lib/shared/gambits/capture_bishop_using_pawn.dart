import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingPawn extends Gambit {
  // singleton logic so that CaptureBishopUsingPawn is only created once
  static final CaptureBishopUsingPawn _singleton =
      CaptureBishopUsingPawn._internal();
  factory CaptureBishopUsingPawn() => _singleton;

  CaptureBishopUsingPawn._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
            ],
            demoFEN:
                'rnb1k2r/pppppppp/8/3Q4/2q1bRn1/3P1P2/PPP1PNPP/1NB1KB1R w Kkq - 0 1',
            title: "Pawn takes Bishop",
            color: Colors.red,
            description: "Capture an enemy bishop with a pawn.",
            altText: "You've been doing WHAT with my tithes?",
            icon: FontAwesomeIcons.chessPawn,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.BISHOP &&
                      move.piece == chess.PieceType.PAWN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => true,
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
