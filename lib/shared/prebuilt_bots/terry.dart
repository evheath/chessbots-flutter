import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final terryCPU = ChessBot(
  gambits: [CaptureRookUsingKnight(), MoveKnightSafely()],
  name: "Tenacious Terry",
);
