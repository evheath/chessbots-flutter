import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final randyCPU = ChessBot(
  gambits: [
    CaptureRandomUsingBishopSafely(),
    DevelopBishop(),
    MoveBishopSafely(),
    CaptureRandomUsingBishop(),
    MoveBishop(),
  ],
  name: "Relentless Randy",
);
