import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final levelFiveCPU = ChessBot(
  gambits: [
    PromotePawnToQueen(),
    CaptureQueen(),
    CaptureUndefendedPiece(),
    CastleKingSide(),
    CastleQueenSide(),
  ],
  name: "Relatively restrained Rick",
);
