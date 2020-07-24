import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final paulCPU = ChessBot(
  gambits: [CapturePawn()],
  name: "Paul pawn snatcher",
);
