import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final hasanCPU = ChessBot(
  gambits: [
    CaptureRandomUsingRook(),
    MoveRandomSafely(),
  ],
  name: "Hasan the hustler",
);
