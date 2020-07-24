import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final travisCPU = ChessBot(
  gambits: [CaptureKnight()],
  name: "Trash talker Travis",
);
