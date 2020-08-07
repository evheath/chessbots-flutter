import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final sadieCPU = ChessBot(
  gambits: [
    CaptureRandomUsingRandom(),
    MoveKnightSafely(),
  ],
  name: "Sadistic Sadie",
);
