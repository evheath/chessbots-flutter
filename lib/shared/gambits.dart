// anytime a gambit gets created here is what needs to happen
// 1) export the gambit file here
// 2) add it to the appropriate category in select_gambit.page.dart
// 3) add it to gambitMap, currently in chess_bot.dart

library gambits;

export './gambits/move_piece_safely.dart';
export './gambits/capture_random_piece.dart';
export './gambits/capture_queen.dart';
export './gambits/capture_rook.dart';
export './gambits/capture_bishop.dart';
export './gambits/capture_knight.dart';
export './gambits/capture_pawn.dart';
export './gambits/capture_undefended_piece.dart';
export './gambits/pawn_to_e4.dart';
export './gambits/move_random_piece.dart';
export './gambits/castle_king_side.dart';
export './gambits/checkmate_opponent.dart';
export './gambits/castle_queen_side.dart';
export './gambits/check_opponent.dart';
export './gambits/move_random_pawn.dart';

export './gambits/promote_pawn_to_random.dart';
export './gambits/promote_pawn_to_queen.dart';
export './gambits/promote_pawn_to_rook.dart';
export './gambits/promote_pawn_to_bishop.dart';
export './gambits/promote_pawn_to_knight.dart';
export './gambits/promote_with_capture.dart';

export './gambits/capture_random_using_bishop.dart';
export './gambits/capture_bishop_using_bishop.dart';
export './gambits/capture_knight_using_bishop.dart';
export './gambits/capture_pawn_using_bishop.dart';
export './gambits/capture_rook_using_bishop.dart';
export './gambits/capture_queen_using_bishop.dart';

export './gambits/capture_random_using_knight.dart';
export './gambits/capture_bishop_using_knight.dart';
export './gambits/capture_knight_using_knight.dart';
export './gambits/capture_pawn_using_knight.dart';
export './gambits/capture_rook_using_knight.dart';
export './gambits/capture_queen_using_knight.dart';

export './gambits/capture_bishop_using_pawn.dart';
export './gambits/capture_knight_using_pawn.dart';
export './gambits/capture_pawn_using_pawn.dart';
export './gambits/capture_queen_using_pawn.dart';
export './gambits/capture_rook_using_pawn.dart';
export './gambits/capture_random_using_pawn.dart';

export './gambits/capture_queen_using_queen.dart';
export './gambits/capture_rook_using_queen.dart';
export './gambits/capture_bishop_using_queen.dart';
export './gambits/capture_knight_using_queen.dart';
export './gambits/capture_pawn_using_queen.dart';
export './gambits/capture_random_using_queen.dart';

export './gambits/capture_bishop_using_king.dart';
export './gambits/capture_knight_using_king.dart';
export './gambits/capture_pawn_using_king.dart';
export './gambits/capture_rook_using_king.dart';
export './gambits/capture_queen_using_king.dart';
export './gambits/capture_random_using_king.dart';

export './gambits/capture_random_using_rook.dart';
export './gambits/capture_pawn_using_rook.dart';
export './gambits/capture_rook_using_rook.dart';
export './gambits/capture_queen_using_rook.dart';
export './gambits/capture_knight_using_rook.dart';
export './gambits/capture_bishop_using_rook.dart';

export './gambits/develop_knight.dart';
export './gambits/develop_bishop.dart';

//non configurable gambits
export './gambits/empty.dart';
