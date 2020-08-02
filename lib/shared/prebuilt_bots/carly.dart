import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final carlyCPU = ChessBot(
  gambits: [CheckOpponentUsingRandom()],
  name: "Callous Carly",
);
