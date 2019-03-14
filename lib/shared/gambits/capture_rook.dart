import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chessbotsmobile/models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureRook extends Gambit {
  // singleton logic so that CaptureRook is only created once
  static final CaptureRook _singleton = CaptureRook._internal();
  factory CaptureRook() => _singleton;

  CaptureRook._internal()
      : super(
            cost: 5,
            demoFEN:
                "rnbqkbn1/ppp1pppp/8/3p1r2/4P3/4N3/PPPP1PPP/RNBQKB1R w KQkq - 0 1",
            vector: WhiteRook(),
            title: "Capture rook",
            color: Colors.red,
            description: "Take one of opponent's rooks.",
            altText: "How will they recover??",
            icon: FontAwesomeIcons.chessRook,
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
                  return pieceBeingCaptured == chess.PieceType.ROOK;
                },
                orElse: () => null,
              );
              return move;
            }));
}
