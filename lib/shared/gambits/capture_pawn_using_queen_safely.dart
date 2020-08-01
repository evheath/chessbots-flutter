import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawnUsingQueenSafely extends Gambit {
  // singleton logic so that CapturePawnUsingQueenSafely is only created once
  static final CapturePawnUsingQueenSafely _singleton =
      CapturePawnUsingQueenSafely._internal();
  factory CapturePawnUsingQueenSafely() => _singleton;

  CapturePawnUsingQueenSafely._internal()
      : super(
            cost: 4,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessPawn),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN: '1r2k2q/p7/4p3/1p2Q1n1/5p2/8/PPpBPPPP/RN2KBNR w KQ - 0 1',
            title: "Queen takes Pawn, safely",
            color: Colors.red,
            description:
                "Capture an enemy pawn with a queen--only if there is no threat of recapture",
            altText:
                "Most peasants die without their king knowing their name. This fool died without even knowing his king's name!",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.PAWN &&
                      move.piece == chess.PieceType.QUEEN)
                  .toList();
              captures.shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
