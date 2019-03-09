import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final peterCPU = ChessBot(
  gambits: [CaptureRandomPiece(), MoveRandomPawn()],
  name: "Peter the pawn pusher",
);
