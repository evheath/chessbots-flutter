import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureQueen extends Gambit {
  // singleton logic so that CaptureQueen is only created once
  static final CaptureQueen _singleton = CaptureQueen._internal();
  factory CaptureQueen() => _singleton;

  CaptureQueen._internal()
      : super(
            demoFEN:
                "rnb1kbn1/ppppp1pr/8/6N1/4P3/7q/PPPP1P1P/RNBQK2R w KQkq - 0 1",
            vector: WhiteQueen(),
            title: "Capture queen",
            color: Colors.red,
            description: "Take your opponent's most valuable piece!",
            altText: "gg ez",
            //TODO find appropriate icon
            icon: Icons.save,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              captures.shuffle();
              String move = captures.firstWhere(
                (capture) {
                  String landingSquare = Gambit.squareOf(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare)?.type;
                  return pieceBeingCaptured == chess.PieceType.QUEEN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
