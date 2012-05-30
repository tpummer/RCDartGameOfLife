#import('../../../dart-sdk/lib/unittest/unittest.dart');

class State {
  const State(this.symbol);

  static final ALIVE = const State('X');
  static final DEAD = const State('_');
  
  final String symbol;
}

class Rule {
  Rule(this.cellState);
  
  reactToNeighbours(int neighbours){
    if(neighbours < 2 || neighbours > 3) {
      cellState = State.DEAD;
    } else if (neighbours == 3) {
      cellState = State.ALIVE;
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
    for (var x=0;x<xCount;x++) {
      for (var y=0;y<yCount;y++) {
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
    test('lonely cell dies', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(1);
      expect(rule.cellIs()).equals(State.DEAD);
    });
    test('proper cell lives on', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(2);
      expect(rule.cellIs()).equals(State.ALIVE);
    });
    test('dead cell with three neighbours will be reborn', (){
      var rule = new Rule(State.DEAD);
      rule.reactToNeighbours(3);
      expect(rule.cellIs()).equals(State.ALIVE);
    });
    test('cell with too many neighbours will die', (){
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(4);
      expect(rule.cellIs()).equals(State.DEAD);
    });
  });
  group('grid', (){
    test('grid has state', (){
      var grid = new Grid(1,1);
      expect(grid.get(0,0)).equals(State.DEAD);
      grid.set(0,0,State.ALIVE);
      expect(grid.get(0,0)).equals(State.ALIVE);
    });
    test('grid has dimension', (){
      var grid = new Grid(2,3);
      expect(grid.get(0,0)).equals(State.DEAD);
      grid.set(0,0,State.ALIVE);
      expect(grid.get(0,0)).equals(State.ALIVE);
      expect(grid.get(1,2)).equals(State.DEAD);
      grid.set(1,2,State.ALIVE);
      expect(grid.get(1,2)).equals(State.ALIVE);
    });
    test('grid is endless', (){
      var grid = new Grid(2,4);
      grid.set(2,4,State.ALIVE);
      expect(grid.get(0,0)).equals(State.ALIVE);
      grid.set(-1,-1,State.ALIVE);
      expect(grid.get(1,3)).equals(State.ALIVE);
    });
    test('grid prints itself', (){
      var grid = new Grid(1,2);
      grid.set(0,1,State.ALIVE);
      expect(grid.print()).equals("_X\n");
    });
    //TODO count
    //TODO next step
  });
}