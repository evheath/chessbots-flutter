import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final tonyCPU = ChessBot(
  gambits: [CaptureRandomUsingRandomSafely()],
  name: "Tireless Tony",
);
