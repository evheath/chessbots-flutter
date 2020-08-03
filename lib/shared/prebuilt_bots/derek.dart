import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final derekCPU = ChessBot(
  gambits: [
    PromotePawnToRook(),
    CheckOpponentUsingRookSafely(),
    CaptureRandomUsingPawn(),
    MovePawnSafely(),
    MovePawn(),
  ],
  name: "Disrespectful Derek",
);
