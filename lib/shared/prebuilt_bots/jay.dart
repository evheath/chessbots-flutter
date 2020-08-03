import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final jayCPU = ChessBot(
  gambits: [
    CheckOpponentUsingRandomSafely(),
    CaptureRookUsingRandom(),
    CapturePawnUsingRandomSafely(),
  ],
  name: "Jailbird Jay",
);
