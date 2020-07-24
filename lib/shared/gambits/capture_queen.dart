import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureQueen extends Gambit {
  // singleton logic so that CaptureQueen is only created once
  static final CaptureQueen _singleton = CaptureQueen._internal();
  factory CaptureQueen() => _singleton;

  CaptureQueen._internal()
      : super(
            cost: 10,
            demoFEN:
                "1nb1kbn1/pppppp1p/2r3r1/8/4B3/3q1p2/PPPPPPPP/RNBQK1NR w KQ - 0 1",
            vector: WhiteQueen(),
            title: "Capture queen",
            color: Colors.red,
            description: "Take the enemy queen using any available piece",
            altText: "Even monarchs can die like commoners",
            icon: FontAwesomeIcons.chessQueen,
            findMove: ((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              captures.shuffle();
              String move = captures.firstWhere(
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
