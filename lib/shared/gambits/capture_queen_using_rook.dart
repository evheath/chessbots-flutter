import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingRook extends Gambit {
  // singleton logic so that CaptureQueenUsingRook is only created once
  static final CaptureQueenUsingRook _singleton =
      CaptureQueenUsingRook._internal();
  factory CaptureQueenUsingRook() => _singleton;

  CaptureQueenUsingRook._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessRook),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen)
            ],
            demoFEN: '4k3/2qpppp1/8/8/pbR1r1Rr/2n5/PPPPPPPP/1NBQKBN1 w - - 0 1',
            title: "Rook takes Queen",
            color: Colors.red,
            description: "Capture an enemy queen with a rook.",
            altText: "Sir, a report from one of the patrols...",
            icon: FontAwesomeIcons.chessRook,
            findMove: ((chess.Chess game) {
              List<dynamic> capturesWithRook = game
                  .moves()
                  .where((move) =>
                      move.toString().contains('R') &&
                      move.toString().contains('x'))
                  .toList();
              capturesWithRook.shuffle();
              String move = capturesWithRook.firstWhere(
                (capture) {
                  String landingSquare = Gambit.landingSquareOfMove(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare)?.type;
                  return pieceBeingCaptured == chess.PieceType.QUEEN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
