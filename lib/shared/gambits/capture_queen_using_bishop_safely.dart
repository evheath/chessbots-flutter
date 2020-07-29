import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/gambit_tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class CaptureQueenUsingBishopSafely extends Gambit {
  // singleton logic so that CaptureQueenUsingBishopSafely is only created once
  static final CaptureQueenUsingBishopSafely _singleton =
      CaptureQueenUsingBishopSafely._internal();
  factory CaptureQueenUsingBishopSafely() => _singleton;

  CaptureQueenUsingBishopSafely._internal()
      : super(
            cost: 6,
            tags: [
              GambitTag(color: Colors.grey, icon: FontAwesomeIcons.chessBishop),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.crosshairs),
              GambitTag(color: Colors.red, icon: FontAwesomeIcons.chessQueen),
              GambitTag(color: Colors.blue, icon: FontAwesomeIcons.lock),
            ],
            demoFEN:
                '1nb1kbn1/pppppp1p/2r3r1/8/4B3/3q1p2/PPPPPPPP/RNBQK1NR w KQ - 0 1',
            title: "Bishop takes Queen, safely",
            color: Colors.red,
            description:
                "Capture an enemy queen with a bishop--only if there is no threat of recapture",
            altText: "Your eulogy is overdue. your majesty",
            icon: FontAwesomeIcons.chessBishop,
            findMove: ((chess.Chess game) {
              List<chess.Move> captures = game
                  .generate_moves()
                  .where((move) =>
                      move.captured == chess.PieceType.QUEEN &&
                      move.piece == chess.PieceType.BISHOP)
                  .toList()
                    ..shuffle();

              chess.Move capture = captures.firstWhere(
                (possibleMove) => Gambit.safeMove(possibleMove, game),
                orElse: () => null,
              );

              return capture == null ? null : game.move_to_san(capture);
            }));
}
