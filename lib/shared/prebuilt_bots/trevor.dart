import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final trevorCPU = ChessBot(
  gambits: [
    CaptureRandomUsingRandomSafely(),
    DevelopBishop(),
    DevelopKnight(),
    DevelopQueen(),
    CastleQueenSide(),
    CastleKingSide(),
    CaptureRandomUsingRandom(),
    MovePawnSafely()
  ],
  name: "Trevor the Try-hard",
);
