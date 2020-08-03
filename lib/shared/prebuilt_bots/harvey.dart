import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final harveyCPU = ChessBot(
  gambits: [
    CaptureRandomUsingRandomSafely(),
    CaptureRandomUsingPawn(),
    CaptureRandomUsingQueen(),
    CaptureRandomUsingRook(),
    CheckOpponentUsingRandomSafely(),
    DevelopKnight(),
    DevelopBishop(),
    DevelopPawn(),
    MoveBishopSafely(),
    MoveKnightSafely(),
  ],
  name: "Heartless Harvey",
);
