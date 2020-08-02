import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final larryCPU = ChessBot(
  gambits: [CapturePawnUsingKing()],
  name: "Lazy Larry",
);
