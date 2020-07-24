import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final franciscoCPU = ChessBot(
  gambits: [CaptureRandomPiece(), CapturePawn(), CastleKingSide()],
  name: "Forlorn Francisco",
);
