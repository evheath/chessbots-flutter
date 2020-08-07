import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final bradCPU = ChessBot(
  gambits: [
    CaptureRandomUsingKnightSafely(),
    DevelopKnight(),
    MoveKnightSafely(),
    CaptureRandomUsingKnight(),
    MoveKnight(),
  ],
  name: "Chadly Bradley",
);
