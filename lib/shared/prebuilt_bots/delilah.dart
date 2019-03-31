import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final delilahCPU = ChessBot(
  gambits: [
    CastleKingSide(),
    CastleQueenSide(),
    CaptureUndefendedPiece(),
    MovePieceSafely(),
  ],
  name: "Delilah the Defensive",
);
