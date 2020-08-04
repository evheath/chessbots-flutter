import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final kenCPU = ChessBot(
  gambits: [CaptureRandomUsingKing(), MoveKing()],
  name: "Criminally crispy Ken",
);
