import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final michaelCPU = ChessBot(
  gambits: [
    PromotePawnToRook(),
    CapturePawnUsingRandom(),
    MovePawn(),
  ],
  name: "Merciless Michael",
);
