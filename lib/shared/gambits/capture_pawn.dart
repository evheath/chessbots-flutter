import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CapturePawn extends Gambit {
  // singleton logic so that CapturePawn is only created once
  static final CapturePawn _singleton = CapturePawn._internal();
  factory CapturePawn() => _singleton;

  CapturePawn._internal()
      : super(
            title: "Capture pawn",
            color: Colors.red,
            description:
                "Take one of opponent's pawns. Small victories add up quickly.",
            //TODO find appropriate icon
            icon: Icons.settings_brightness,
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
                  return pieceBeingCaptured == chess.PieceType.PAWN;
                },
                orElse: () => null,
              );
              return move;
            }));
}
