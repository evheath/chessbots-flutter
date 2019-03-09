import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final levelOneCPU = ChessBot(
  gambits: [CaptureRandomPiece()],
  name: "Garrett the greedy",
);
