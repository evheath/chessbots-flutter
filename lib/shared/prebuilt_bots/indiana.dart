import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final indianaCPU = ChessBot(
  gambits: [
    CaptureRandomUsingPawnSafely(),
    CaptureRandomUsingPawn(),
    MovePawnSafely(),
  ],
  name: "Indefatigable Indiana",
);
