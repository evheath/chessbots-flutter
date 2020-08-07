import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final dennisCPU = ChessBot(
  gambits: [DevelopBishop(), DevelopKnight()],
  name: "Developer Dennis",
);
