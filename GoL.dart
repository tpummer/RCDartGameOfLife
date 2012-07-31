#import('../../../../../privat/dart/dart-sdk/lib/unittest/unittest.dart');

// see http://rosettacode.org/wiki/Conway%27s_Game_of_Life

class State {
  const State(this.symbol, this.value);

  static final ALIVE = const State('#', 1);
  static final DEAD = const State(' ', 0);

  final String symbol;
  final int value;
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

  State cellIs() {
    return cellState;
  }

  var cellState;
}

class Grid {
  Grid(this.xCount, this.yCount) {
    field = new Map();
  }

  set(x, y, state){
    field[pos(x,y)] = state;
  }

  State get(x, y){
    var state = field[pos(x,y)];
    return state != null ? state : State.DEAD;
  }

  static final LEFT = -1;
  static final RIGHT = 1;
  static final UP = -1;
  static final DOWN = 1;
  
  int countLiveNeighbours(x, y) {
    return get(x+LEFT, y+UP).value +   get(x, y+UP).value +   get(x+RIGHT, y+UP).value + 
           get(x+LEFT, y).value +                             get(x+RIGHT, y).value +
           get(x+LEFT, y+DOWN).value + get(x, y+DOWN).value + get(x+RIGHT, y+DOWN).value;
  }

  pos(x, y) {
    return '${(x+xCount)%xCount}:${(y+yCount)%yCount}';
  }

  print() {
    var sb = new StringBuffer();
    iterate((x,y) { sb.add(get(x,y).symbol); }, 
            (x) { sb.add("\n"); });
    return sb.toString();
  }
  
  iterate(innerBody, [outerBody=null]) {
    for (var x=0; x<xCount; x++) {
      for (var y=0; y<yCount; y++) {
         innerBody(x,y);
      }
      if(outerBody != null) {
        outerBody(x);
      }
    }
  }

  final xCount, yCount;
  var field;
}

class Game {
  Game(Grid this.grid);
  
  tick() {
    var newGrid = new Grid(this.grid.xCount, this.grid.yCount);

    grid.iterate((x,y) {
      var rule = new Rule(grid.get(x, y)); 
      rule.reactToNeighbours(grid.countLiveNeighbours(x, y));
      newGrid.set(x, y, rule.cellIs());
    });
    
    this.grid = newGrid;
  }
  
  var grid;
}

main() {
  group('rules', () {
    test('should let living but lonely cell die', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(1);
      expect(rule.cellIs(), State.DEAD);
    });
    test('should let proper cell live on', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(2);
      expect(rule.cellIs(), State.ALIVE);
    });
    test('should let dead cell with three neighbours be reborn', () {
      var rule = new Rule(State.DEAD);
      rule.reactToNeighbours(3);
      expect(rule.cellIs(), State.ALIVE);
    });
    test('should let living cell with too many neighbours die', () {
      var rule = new Rule(State.ALIVE);
      rule.reactToNeighbours(4);
      expect(rule.cellIs(), State.DEAD);
    });
  });

  group('grid', () {
    test('should have state', () {
      var grid = new Grid(1,1);
      expect(grid.get(0,0), State.DEAD);
      grid.set(0,0, State.ALIVE);
      expect(grid.get(0,0), State.ALIVE);
    });
    test('should have dimension', () {
      var grid = new Grid(2,3);
      expect(grid.get(0,0), State.DEAD);
      grid.set(0,0, State.ALIVE);
      expect(grid.get(0,0), State.ALIVE);
      expect(grid.get(1,2), State.DEAD);
      grid.set(1,2, State.ALIVE);
      expect(grid.get(1,2), State.ALIVE);
    });
    test('should be endless', () {
      var grid = new Grid(2,4);
      grid.set(2,4, State.ALIVE);
      expect(grid.get(0,0), State.ALIVE);
      grid.set(-1,-1, State.ALIVE);
      expect(grid.get(1,3), State.ALIVE);
    });
    test('should print itself', () {
      var grid = new Grid(1,2);
      grid.set(0,1,State.ALIVE);
      expect(grid.print(), " #\n");
    });
  });

  group('game', () {
    test('should exists', () {
     var game = new Game(null);
     expect(game, isNotNull);
    });
    test('should create a new grid when ticked', () {
      var grid = new Grid(1,1);
      var game = new Game(grid);
      game.tick();
      expect(game.grid !== grid);
    });
    test('should have a grid with the same dimension after tick', (){
      var grid = new Grid(2,3);
      var game = new Game(grid);
      game.tick();
      expect(game.grid.xCount, 2);
      expect(game.grid.yCount, 3);
    });
    test('should apply rules to middle cell', (){
      var grid = new Grid(3,3);
      grid.set(1, 1, State.ALIVE);
      var game = new Game(grid);
      game.tick();
      expect(game.grid.get(1, 1), State.DEAD);
      
      grid.set(0, 0, State.ALIVE);
      grid.set(1, 0, State.ALIVE);
      game = new Game(grid);
      game.tick();
      expect(game.grid.get(1, 1), State.ALIVE);
    });
    test('should apply rules to all cells', (){
      var grid = new Grid(3,3);
      grid.set(0, 1, State.ALIVE);
      grid.set(1, 0, State.ALIVE);
      grid.set(1, 1, State.ALIVE);
      var game = new Game(grid);
      game.tick();
      expect(game.grid.get(0, 0), State.ALIVE);
    });
  });
  
  runBlinker();

}

runBlinker(){
  var blinker = getBlinker();
  var game = new Game(blinker);
  for(int i = 0; i < 3; i++){
    print(game.grid.print());
    game.tick();
  }
  print(game.grid.print());
}

getBlinker(){
  var grid = new Grid(4, 4);
  grid.set(0, 1, State.ALIVE);
  grid.set(1, 1, State.ALIVE);
  grid.set(2, 1, State.ALIVE);
  return grid;
}
