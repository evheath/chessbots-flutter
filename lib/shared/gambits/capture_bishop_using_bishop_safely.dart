import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureBishopUsingBishopSafely extends Gambit {
  // singleton logic so that CaptureBishopUsingBishopSafely is only created once
  static final CaptureBishopUsingBishopSafely _singleton =
      CaptureBishopUsingBishopSafely._internal();
  factory CaptureBishopUsingBishopSafely() => _singleton;

  CaptureBishopUsingBishopSafely._internal()
      : super(
            cost: 2,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                'rn2k2r/pQpppppp/3bq2n/1b6/2B2BN1/8/PPPPPPPP/RN2K2R w KQkq - 0 1',
            title: "Bishop takes Bishop, safely",
            color: Colors.red,
            description: "Capture an undefended enemy bishop with your own.",
            altText: "The false prophet has false support",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> bTakesBMoves = game
                  .generate_moves()
                  .where((move) =>
                      move.piece == chess.PieceType.BISHOP &&
                      move.captured == chess.PieceType.BISHOP)
                  .toList()
                    ..shuffle();
              chess.Move move = bTakesBMoves.firstWhere(
                (bTakesBMove) => Gambit.safeMove(bTakesBMove, game),
                orElse: () => null,
              );

              return move == null ? null : game.move_to_san(move);
            }));
}
