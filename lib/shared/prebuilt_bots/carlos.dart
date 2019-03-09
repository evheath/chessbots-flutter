import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final carlosCPU = ChessBot(
  gambits: [
    CaptureUndefendedPiece(),
    MovePieceSafely(),
  ],
  name: "Relatively restrained Rick",
);
