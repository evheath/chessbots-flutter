import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final oscarCPU = ChessBot(
  gambits: [EmptyGambit()],
  name: "Oscar the oblivious",
);
