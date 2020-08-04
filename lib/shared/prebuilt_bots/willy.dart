import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final willyCPU = ChessBot(
  gambits: [
    PromotePawnToRook(),
    DevelopBishop(),
    DevelopKnight(),
    CaptureRandomUsingBishop(),
    CaptureRandomUsingKnight(),
    CheckOpponentUsingRookSafely(),
    MoveRookSafely(),
  ],
  name: "Wellrounded Willy",
);
