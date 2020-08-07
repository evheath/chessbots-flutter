import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final jessicaCPU = ChessBot(
  gambits: [
    CaptureRandomUsingRandomSafely(),
    DevelopKnight(),
    DevelopBishop(),
    CheckOpponentUsingKnightSafely(),
    CheckOpponentUsingBishopSafely(),
    MoveBishopSafely(),
    MoveKnightSafely(),
    MovePawn(),
  ],
  name: "Judicious Jessica",
);
