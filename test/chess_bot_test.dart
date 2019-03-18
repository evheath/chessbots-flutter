import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:test/test.dart';

void main() {
  ChessBot _bot = ChessBot();
  group('Bot public methods', () {
    test('Bounty is not 0', () {
      expect(_bot.bounty, greaterThan(0));
    });
  });
}
