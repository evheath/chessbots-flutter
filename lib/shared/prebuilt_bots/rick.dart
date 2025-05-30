import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final rickCPU = ChessBot(
  gambits: [
    PromotePawnToQueen(),
    CaptureQueenUsingRandom(),
    CaptureRandomUsingRandomSafely(),
    CastleKingSide(),
    CastleQueenSide(),
  ],
  name: "Restrained Rick",
);
