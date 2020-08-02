import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final steveCPU = ChessBot(
  gambits: [CapturePawnUsingPawn(), CaptureRandomUsingQueen()],
  name: "Sweaty Steve",
);
