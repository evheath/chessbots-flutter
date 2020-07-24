import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final rickCPU = ChessBot(
  gambits: [
    PromotePawnToQueen(),
    CaptureQueen(),
    CaptureUndefendedPiece(),
    CastleKingSide(),
    CastleQueenSide(),
  ],
  name: "Restrained Rick",
);
