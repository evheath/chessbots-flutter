import 'package:chessbotsmobile/models/gambit.dart';
import 'package:test/test.dart';

void main() {
  group('Landing square Regex', () {
    test('Pawn move', () {
      expect(Gambit.landingSquareOfMove('a4'), 'a4');
    });
    test('Pawn capture', () {
      expect(Gambit.landingSquareOfMove('bxa4'), 'a4');
    });
    test('Piece capture', () {
      expect(Gambit.landingSquareOfMove('Nxa4'), 'a4');
      expect(Gambit.landingSquareOfMove('Bxa4'), 'a4');
      expect(Gambit.landingSquareOfMove('Qxa4'), 'a4');
      expect(Gambit.landingSquareOfMove('Kxa4'), 'a4');
      expect(Gambit.landingSquareOfMove('Rxa4'), 'a4');
    });

    test('Disambiguous move', () {
      expect(Gambit.landingSquareOfMove('Nbd2'), 'd2');
    });
    test('Disambiguous capture', () {
      expect(Gambit.landingSquareOfMove('Nbxd2'), 'd2');
    });
    test('Capture with check', () {
      expect(Gambit.landingSquareOfMove('Qxf2+'), 'f2');
    });
    test('Check', () {
      expect(Gambit.landingSquareOfMove('Bh4+'), 'h4');
    });

    test('Capture, Promotion, check', () {
      expect(Gambit.landingSquareOfMove('fxg8=Q+'), 'g8');
    });
  });
}
