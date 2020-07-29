import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final garrettCPU = ChessBot(
  gambits: [CaptureRandomUsingRandom()],
  name: "Garrett the greedy",
);
