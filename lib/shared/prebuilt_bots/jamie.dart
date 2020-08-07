import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final jamieCPU = ChessBot(
  gambits: [
    DevelopRook(),
    CaptureRandomUsingRookSafely(),
    CheckOpponentUsingRandomSafely(),
    MovePawnSafely(),
    MoveRookSafely(),
  ],
  name: "'Don't blame me' Jamie",
);
