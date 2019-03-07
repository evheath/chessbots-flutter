import 'package:chessbotsmobile/bloc/chess_bot.bloc.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

final levelZeroCPU = ChessBot(gambits: [EmptyGambit()], name: "Level 0 CPU");
