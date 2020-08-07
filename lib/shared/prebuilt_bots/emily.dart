import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final emilyCPU = ChessBot(
  gambits: [
    CaptureQueenUsingPawn(),
    CapturePawnUsingRandomSafely(),
  ],
  name: "Erratic Emily",
);
