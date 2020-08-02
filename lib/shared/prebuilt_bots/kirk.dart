import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final kirkCPU = ChessBot(
  gambits: [CaptureRandomUsingKnight()],
  name: "Careless Kirk",
);
