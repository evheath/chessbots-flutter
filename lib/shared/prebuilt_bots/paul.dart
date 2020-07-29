import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final paulCPU = ChessBot(
  gambits: [CapturePawnUsingRandom()],
  name: "Paul pawn snatcher",
);
