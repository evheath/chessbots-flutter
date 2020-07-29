import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/shared/gambits.dart';

/// A list of all the gambit singletons
final List<Gambit> allGambits = [
  // pawn takes...
  CaptureRandomUsingPawn(),
  CaptureBishopUsingPawn(),
  CaptureKnightUsingPawn(),
  CapturePawnUsingPawn(),
  CaptureQueenUsingPawn(),
  CaptureRookUsingPawn(),
  // CaptureRandomUsingPawnSafely(),
  // CaptureBishopUsingPawnSafely(),
  // CaptureKnightUsingPawnSafely(),
  // CapturePawnUsingPawnSafely(),
  // CaptureQueenUsingPawnSafely(),
  // CaptureRookUsingPawnSafely(),

  // bishop takes...
  CaptureRandomUsingBishop(),
  CaptureBishopUsingBishop(),
  CaptureKnightUsingBishop(),
  CapturePawnUsingBishop(),
  CaptureRookUsingBishop(),
  CaptureQueenUsingBishop(),
  CaptureBishopUsingBishopSafely(),
  CaptureRandomUsingBishopSafely(),
  CaptureKnightUsingBishopSafely(),
  CapturePawnUsingBishopSafely(),
  CaptureRookUsingBishopSafely(),
  CaptureQueenUsingBishopSafely(),

  // knight takes...
  CaptureRandomUsingKnight(),
  CaptureBishopUsingKnight(),
  CaptureKnightUsingKnight(),
  CapturePawnUsingKnight(),
  CaptureRookUsingKnight(),
  CaptureQueenUsingKnight(),
  // CaptureRandomUsingKnightSafely(),
  // CaptureBishopUsingKnightSafely(),
  // CaptureKnightUsingKnightSafely(),
  // CapturePawnUsingKnightSafely(),
  // CaptureRookUsingKnightSafely(),
  // CaptureQueenUsingKnightSafely(),

  // queen takes...
  CaptureRandomUsingQueen(),
  CaptureQueenUsingQueen(),
  CaptureRookUsingQueen(),
  CaptureBishopUsingQueen(),
  CaptureKnightUsingQueen(),
  CapturePawnUsingQueen(),
  // CaptureRandomUsingQueenSafely(),
  // CaptureQueenUsingQueenSafely(),
  // CaptureRookUsingQueenSafely(),
  // CaptureBishopUsingQueenSafely(),
  // CaptureKnightUsingQueenSafely(),
  // CapturePawnUsingQueenSafely(),

  // king takes...
  CaptureBishopUsingKing(),
  CaptureKnightUsingKing(),
  CapturePawnUsingKing(),
  CaptureRookUsingKing(),
  CaptureQueenUsingKing(),
  CaptureRandomUsingKing(),

  // rook takes...
  CapturePawnUsingRook(),
  CaptureRookUsingRook(),
  CaptureQueenUsingRook(),
  CaptureKnightUsingRook(),
  CaptureBishopUsingRook(),
  CaptureRandomUsingRook(),
  // CapturePawnUsingRookSafely(),
  // CaptureRookUsingRookSafely(),
  // CaptureQueenUsingRookSafely(),
  // CaptureKnightUsingRookSafely(),
  // CaptureBishopUsingRookSafely(),
  // CaptureRandomUsingRookSafely(),

  // random takes...
  CaptureRandomUsingRandom(),
  CaptureKnightUsingRandom(),
  CapturePawnUsingRandom(),
  CaptureQueenUsingRandom(),
  CaptureRookUsingRandom(),
  CaptureBishopUsingRandom(),
  CaptureRandomUsingRandomSafely(),
  CaptureKnightUsingRandomSafely(),
  CaptureQueenUsingRandomSafely(),
  CaptureRookUsingRandomSafely(),
  CapturePawnUsingRandomSafely(),
  CaptureBishopUsingRandomSafely(),

  // checks
  CheckOpponentUsingRandom(),
  CheckOpponentUsingPawn(),
  CheckOpponentUsingKnight(),
  CheckOpponentUsingBishop(),
  CheckOpponentUsingRook(),
  CheckOpponentUsingQueen(),
  CheckOpponentUsingRandomSafely(),
  CheckOpponentUsingPawnSafely(),
  CheckOpponentUsingKnightSafely(),
  CheckOpponentUsingBishopSafely(),
  CheckOpponentUsingRookSafely(),
  CheckOpponentUsingQueenSafely(),

  // castling
  CastleKingSide(),
  CastleQueenSide(),

  // promotions
  PromotePawnToQueen(),
  PromotePawnToRook(),
  PromotePawnToBishop(),
  PromotePawnToKnight(),
  PromotePawnToRandom(),
  PromoteWithCapture(),

  // movement
  MovePawn(),
  MoveKnight(),
  MoveBishop(),
  MoveRook(),
  MoveQueen(),
  MoveKing(),
  MoveRandomSafely(),
  MoveQueenSafely(),
  MoveRookSafely(),
  MovePawnSafely(),
  MoveKnightSafely(),
  MoveBishopSafely(),
  DevelopKnight(),
  DevelopBishop(),
  DevelopQueen(),
  DevelopRook(),
  DevelopPawn(),
];

/// Given a gambit's title, this map returns an instance corresponding gambit's singleton
///
/// Can be used to stand up a bot that was serialized in the db
Map<String, Gambit> gambitMap = Map.fromIterable(
  allGambits,
  key: (gambit) => gambit.title,
  value: (gambit) => gambit,
)..addAll({
    CheckmateOpponent().title: CheckmateOpponent(),
    MoveRandomPiece().title: MoveRandomPiece(),
    EmptyGambit().title: EmptyGambit(),
  });
