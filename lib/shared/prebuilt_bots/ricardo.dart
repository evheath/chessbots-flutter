import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final ricardoCPU = ChessBot(
  gambits: [CaptureBishopUsingRandom(), CaptureKnightUsingRandom()],
  name: "Reasonable Ricardo",
);
