import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final pabloCPU = ChessBot(
  gambits: [CaptureRandomUsingBishop()],
  name: "Pernicious Pablo",
);
