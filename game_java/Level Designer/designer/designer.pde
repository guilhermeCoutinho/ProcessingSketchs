int cols, rows;
float sq_w, sq_h;
private final static int PRIMEIRA_VEZ = 1;
private final static int DEMAIS_VEZES = 2;
private final static int WHITE = 1;
private final static int GRAY = 2;

int gameStage ;
Grid grid;

void setup () {
  size (240, 320);
  cols = 4;
  rows = 10;
  noLoop();  
  gameStage = PRIMEIRA_VEZ;
}

void draw () {

  switch (gameStage) {
  case PRIMEIRA_VEZ: 
    {
      background (255);
      sq_w = (width / cols);
      sq_h = (height/ rows);
      gameStage = DEMAIS_VEZES;
      createGrid ();
      drawGrid();
    }
    break;
  case DEMAIS_VEZES:
    {
      int m =  floor (map (mouseX, 0, width, 0, cols ) );
      int n =  floor (map (mouseY, 0, height, 0, rows ) );
      m = floor (m * sq_w );
      n = floor (n * sq_h );
      grid.changeColor(m,n);
      drawGrid();
    }
  }
}

void drawGrid () {
  for (int i = 0; i < grid.map.size (); i ++ ) {
    if ( grid.map.get(i).cor == WHITE ) {fill (255);
    }else {fill(140);}
    rect (grid.map.get(i).x, grid.map.get(i).y, sq_w, sq_h );
  }
}

void createGrid () {
  grid = new Grid();
  for (  int i = 0; i < cols; i ++ ) {
    for (  int j = 0; j < rows; j ++ ) {

      int m =  floor (map (i*sq_w, 0, cols*sq_w, 0, cols ) );
      int n =  floor (map (j*sq_h, 0, rows*sq_h , 0, rows ) );
      m = floor (m * sq_w );
      n = floor (n * sq_h );
      grid.map.add(new Square( m, n, WHITE) );
    }
  }
//  println (grid.map.size());
//  grid.listSq();
}


void mouseDragged () {
  redraw();
}

void mousePressed () {
  redraw();
}


private class Grid {
  ArrayList<Square> map = new ArrayList<Square>();
  
  private int returnSquare (int x , int y ) {  
    
    for (int i = 0 ; i < map.size() ; i ++ ) {
        if ( x == map.get(i).x && y == map.get(i).y){
          return  i;
        }
    }
    return -1;
  }
  
  public void listSq () {
    for ( int i = 0 ; i < map.size();i++){
      println ("x:",map.get(i).x , "y:", map.get(i).y);
    }
  }
  
  public void changeColor (int x , int y ) {
    int i = returnSquare ( x , y );
    if ( i != -1 ) {
      if ( map.get(i).cor == WHITE ) {
        
        map.get(i).cor = GRAY;
      }else {
        map.get(i).cor = WHITE;
      }
    }
  }
}

private class Square {
  int cor ;
  int x;
  int y;

  Square (int x, int y) {
    this.x = x;
    this.y = y;
  }
  Square (int x, int y, int cor) {
    this.x = x;
    this.y = y;
    this.cor = cor;
  }
  
  
}

