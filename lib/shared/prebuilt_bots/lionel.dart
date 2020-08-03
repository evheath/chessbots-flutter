import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final lionelCPU = ChessBot(
  gambits: [
    CaptureRandomUsingKnightSafely(),
    DevelopKnight(),
    CheckOpponentUsingKnightSafely(),
    MoveKnightSafely(),
  ],
  name: "Lionel Lionheart",
);
