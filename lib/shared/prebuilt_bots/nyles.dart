import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final nylesCPU = ChessBot(
  gambits: [CaptureRandomUsingBishop(), MoveBishopSafely()],
  name: "Nyles the nervous",
);
