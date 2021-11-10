class Board {
  final int width;
  final int height;
  final List<List<int>> spots = [];

  Board(this.width, this.height) {
    for(int i = 0; i < width; i++) {
      spots.add([]);
      for(int j = 0; j < height; j++) {
        spots[i].add(0);
      }
    }
  }

  bool placeSlot(int slot, int player) {
    if(slot < 0 || width <= slot) return false;
    if(isColumnFull(slot)) return false;

    var h = columnHeight(slot);
    spots[slot][h] = player;
    return true;
  }

  int columnHeight(int column) {
    for(int i = 0; i < height; i++) {
      if(spots[column][i] == 0) return i;
    }

    return height;
  }

  bool isColumnFull(int slot) {
    return spots[slot][spots[slot].length - 1] != 0;
  }

  @override
  String toString() {
    String rtn = '';
    for(int j = height - 1; j >= 0; j--) {
      for(int i = 0; i < width; i++) {
        rtn += '${spots[i][j]}\t';
      }
      rtn += '\n';
    }

    return rtn;
  }
}