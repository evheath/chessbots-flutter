import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final halCPU = ChessBot(
  gambits: [
    CaptureQueenUsingRandom(),
    CaptureRandomUsingRandomSafely(),
    CaptureRandomUsingPawn(),
    CaptureRookUsingBishop(),
    CaptureRookUsingKnight(),
    MoveRandomSafely(),
  ],
  name: "Hellacious Hal",
);
