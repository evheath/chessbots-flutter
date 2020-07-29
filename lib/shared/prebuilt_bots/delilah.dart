import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final delilahCPU = ChessBot(
  gambits: [
    CastleKingSide(),
    CastleQueenSide(),
    CaptureRandomUsingRandomSafely(),
    MoveRandomSafely(),
  ],
  name: "Delilah the Defensive",
);
