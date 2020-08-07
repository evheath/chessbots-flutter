import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final franciscoCPU = ChessBot(
  gambits: [
    CaptureRandomUsingRandom(),
    CapturePawnUsingRandom(),
    CastleKingSide()
  ],
  name: "Forlorn Francisco",
);
