import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingQueenSafely extends Gambit {
  // singleton logic so that CaptureQueenUsingQueenSafely is only created once
  static final CaptureQueenUsingQueenSafely _singleton =
      CaptureQueenUsingQueenSafely._internal();
  factory CaptureQueenUsingQueenSafely() => _singleton;

  CaptureQueenUsingQueenSafely._internal()
      : super(
            cost: 5,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'r3k3/pppp1p2/4pn2/n1q5/8/2Q4r/PP1BPPPP/RN2KBNR w KQq - 0 1',
            title: "Queen takes Queen, safely",
            color: Colors.red,
            description:
                "Capture an enemy queen with your own--only if there is no threat of recapture",
            altText: "The three of us agreed this had to be done.",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
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
