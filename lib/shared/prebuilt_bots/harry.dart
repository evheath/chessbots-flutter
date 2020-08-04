import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final harryCPU = ChessBot(
  gambits: [CaptureBishopUsingRandomSafely()],
  name: "Heretical Harry",
);
