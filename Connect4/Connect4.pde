private static final int ROWS = 6;
private static final int COLS = 7;

private static float PIECE_H , PIECE_W;
private int colClicked;

Grid grid;


void setup ()  {
  size(700,600);
  PIECE_H = height / ROWS;
  PIECE_W = width / COLS;
  noLoop();
  grid = new Grid (ORANGE) ;
}

void draw () {  
  
  background(200);
  strokeWeight(6);
  
  for (int i = 1 ; i <= ROWS ; i ++ ) {
    line (0,PIECE_H*i , width , PIECE_H*i);
  }
 
  for ( int i = 0 ; i <= COLS ; i ++ ) {
    line (PIECE_W*i , 0 , PIECE_W*i , height );
  }
  
  for ( float i = PIECE_H / 2 ; i <= height ; i+= PIECE_H ) {
    for (float j = PIECE_W /2 ; j <= width ; j+= PIECE_W){
      int x = (int)i / (int) PIECE_H; //println("i" , i , "piece_w" , PIECE_H);
      int y = (int)j / (int) PIECE_W;
      
      switch (grid.getCorPiece(x,y) ) {
        case BLANK:fill(255);
        break;
        case ORANGE:fill(#FF9A03);
        break;
        case BLACK:fill(0);
        break;
      }

      ellipse (j , i , PIECE_W/2 , PIECE_H/2);
    }
  }
  
}


void mouseClicked () {
  colClicked = mouseX / (int) PIECE_W ;
  grid.makeMove(colClicked);
  redraw();

}
