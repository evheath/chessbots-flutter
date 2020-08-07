import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final travisCPU = ChessBot(
  gambits: [CaptureKnightUsingRandom()],
  name: "Trash talker Travis",
);
