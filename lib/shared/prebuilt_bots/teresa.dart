import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final teresaCPU = ChessBot(
  gambits: [
    CaptureUndefendedPiece(),
    PromotePawnToRook(),
    MoveRandomPawn(),
  ],
  name: "Motherless Teresa",
);
