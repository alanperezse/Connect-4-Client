import 'package:connect4/board.dart';
import 'package:connect4/coordinates.dart';

class Game {
  var board;
  static const int empty = 0;
  static const int player = 1;
  static const int machine = 2;
  static const int win = 3;
  Map symbols = {
    empty : '·',
    win : '♬'
  };
  List? winRow = null;
  int? lastMove = null;

  Game(int width, int height, String playerSymbol, String machineSymbol) {
    board = Board(width, height);
    symbols[player] = playerSymbol[0];
    symbols[machine] = machineSymbol[0];
  }

  makePlayerMove(int slot) {
    bool rtn = board.placeSlot(slot - 1, player);
    if(rtn) lastMove = slot;
    return rtn;
  }

  makeMachineMove(int slot) {
    bool rtn = board.placeSlot(slot - 1, machine);
    if(rtn) lastMove = slot;
    return rtn;
  }

  bool isWinCoord(int x, int y) {
    for(var coord in winRow!) {
      if(coord.x - 1 == x && coord.y - 1 == y) return true;
    }

    return false;
  }

  @override
  String toString() {
    List<String> rtn = List.filled(0, '', growable: true);

    for(int j = board.height - 1; j >= 0; j--) {
      for(int i = 0; i < board.width; i++) {
        var spot = board.spots[i][j];
        rtn.add(winRow != null && isWinCoord(i, j) ? symbols[win] : symbols[spot]!);
        rtn.add('\t');
      }
      rtn.add('\n');
    }

    // Visual hint to choose slot
    rtn.add(List<int>.generate(board.width, (i) => i + 1).join('\t'));
    rtn.add('\n');

    // Visual hint to indicate last move
    if(lastMove != null) {
      rtn.add('\t' * (lastMove! - 1));
      rtn.add('*\n');
    }

    rtn.add('\n');

    // More efficient than string concatenation
    return rtn.join('');
  }
}
