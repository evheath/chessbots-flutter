import 'package:chessbotsmobile/bloc/chess_bot.bloc.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final levelOneCPU = ChessBot(
  gambits: [CaptureRandomPiece()],
  name: "Garrett the greedy",
  level: 1,
  value: 6,
);
