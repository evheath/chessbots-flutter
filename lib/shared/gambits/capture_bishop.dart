import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class CaptureBishop extends Gambit {
  // singleton logic so that CaptureBishop is only created once
  static final CaptureBishop _singleton = CaptureBishop._internal();
  factory CaptureBishop() => _singleton;

  CaptureBishop._internal()
      : super(
            vector: WhiteBishop(),
            title: "Capture bishop",
            color: Colors.red,
            description: "Take one of opponent's bishops.",
            //TODO find appropriate icon
            icon: Icons.sentiment_very_satisfied,
            findMove: FindMove((chess.Chess game) {
              List<dynamic> captures = game
                  .moves()
                  .where((move) => move.toString().contains('x'))
                  .toList();
              String move = captures.firstWhere(
                (capture) {
                  String landingSquare = Gambit.squareOf(capture);
                  chess.PieceType pieceBeingCaptured =
                      game.get(landingSquare)?.type;
                  return pieceBeingCaptured == chess.PieceType.BISHOP;
                },
                orElse: () => null,
              );
              return move;
            }));
}
