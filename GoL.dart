#import('../../../dart-sdk/lib/unittest/unittest.dart');

// see http://rosettacode.org/wiki/Conway%27s_Game_of_Life

class State {
  const State(this.symbol);

  static final ALIVE = const State('#');
  static final DEAD = const State(' ');

  final String symbol;
}

class Rule {
  Rule(this.cellState);

  reactToNeighbours(int neighbours){
    if (neighbours == 3) {
      cellState = State.ALIVE;
    } else if (neighbours != 2) {
      cellState = State.DEAD;
    }
  }

  cellIs() {
    return cellState;
  }

  var cellState;
}

class Grid {
  Grid(this.xCount, this.yCount) {
    field = new Map();
  }

  set(int x, int y, State state){
    field[pos(x,y)] = state;
  }

  get(int x, int y){
    var state = field[pos(x,y)];
    return state != null ? state : State.DEAD;
  }

  pos(x,y) {
    return '${(x+xCount)%xCount}:${(y+yCount)%yCount}';
  }

  print() {
    var sb = new StringBuffer();
    for (var x=0; x<xCount; x++) {
      for (var y=0; y<yCount; y++) {
        sb.add(get(x,y).symbol);
      }
      sb.add("\n");
    }
    return sb.toString();
  }

  final xCount, yCount;
  var field;
}

main() {
  group('rules', () {
    test('should let living but lonely cell die', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(1);
      expect(rule.cellIs()).equals(State.DEAD);
    });
    test('should let proper cell live on', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(2);
      expect(rule.cellIs()).equals(State.ALIVE);
    });
    test('should let dead cell with three neighbours be reborn', () {
      var rule = new Rule(State.DEAD);
      rule.reactToNeighbours(3);
      expect(rule.cellIs()).equals(State.ALIVE);
    });
    test('should let living cell with too many neighbours die', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(4);
      expect(rule.cellIs()).equals(State.DEAD);
    });
  });

  group('grid', () {
    test('should have state', () {
      var grid = new Grid(1,1);
      expect(grid.get(0,0)).equals(State.DEAD);
      grid.set(0,0,State.ALIVE);
      expect(grid.get(0,0)).equals(State.ALIVE);
    });
    test('should have dimension', () {
      var grid = new Grid(2,3);
      expect(grid.get(0,0)).equals(State.DEAD);
      grid.set(0,0,State.ALIVE);
      expect(grid.get(0,0)).equals(State.ALIVE);
      expect(grid.get(1,2)).equals(State.DEAD);
      grid.set(1,2,State.ALIVE);
      expect(grid.get(1,2)).equals(State.ALIVE);
    });
    test('should be endless', () {
      var grid = new Grid(2,4);
      grid.set(2,4,State.ALIVE);
      expect(grid.get(0,0)).equals(State.ALIVE);
      grid.set(-1,-1,State.ALIVE);
      expect(grid.get(1,3)).equals(State.ALIVE);
    });
    test('should print itself', () {
      var grid = new Grid(1,2);
      grid.set(0,1,State.ALIVE);
      expect(grid.print()).equals(" #\n");
    });
  });

  group('game', () {
    //TODO should count neigbours
    //TODO should update grid in a step
  });

  //TODO run blinker in 3x3 for 3 iterations,
}
