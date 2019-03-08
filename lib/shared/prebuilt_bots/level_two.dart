import 'package:chessbotsmobile/bloc/chess_bot.bloc.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final levelTwoCPU = ChessBot(
  value: 10,
  level: 2,
  gambits: [CaptureRandomPiece(), MoveRandomPawn()],
  name: "Peter the pawn pusher",
);
