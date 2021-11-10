import 'package:connect4/board.dart';
import 'package:test/test.dart';


void main() {
  test('isSlotFull', () {
    // Empty board
    var board = Board(7, 6);
    for(int i = 0; i < 7; i++) {
      expect(board.isColumnFull(i), false);
    }
  });

  test('columnHeight', () {
    // Empty board
    var board = Board(7, 6);
    for(int i = 0; i < 7; i++) {
      expect(board.columnHeight(i), 0);
    }

    // Board with a few slots
    board.spots[0][0] = 1;
    board.spots[0][1] = 1;
    board.spots[3][0] = 1;
    board.spots[4][0] = 1;
    board.spots[5][0] = 1;
    expect(board.columnHeight(0), 2);
    expect(board.columnHeight(3), 1);
    expect(board.columnHeight(4), 1);
    expect(board.columnHeight(5), 1);
  });
}
