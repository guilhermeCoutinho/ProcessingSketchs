private static final int ROWS = 6;
private static final int COLS = 7;

private static float PIECE_H , PIECE_W;
private int colClicked;

private static final int MENU = 1;
private static final int GAME_RUNNING =2;
private static final int GAME_FINISHED = 3;
private int gameStage;
private int colorChoice;
Grid grid;


void setup ()  {
  size(240,320);
  PIECE_H = height / ROWS;
  PIECE_W = width / COLS;
  grid = new Grid (ORANGE) ;
  gameStage = MENU;
}

void draw () {  
  
  switch (gameStage) {
   case MENU: 
     textSize();
     fill(#FF9A03);
     rect(0,0,width/2,height);
     fill(0);
     rect(width/2,0,width/2,height);
     text("ORANGE" , width/4,height/2);
     fill(#FF9A03);
     text("BLACK" , 3*width/4 , height/2 );
     stroke(255);strokeWeight(10);
     line(width/2 , 0 , width/2 , height );
     if (mousePressed) {
       if ( mouseX < width / 2 )println ("ORANGE");
       else println ("BLACK");
       gameStage = GAME_RUNNING;
     }
   break;
   
   case GAME_RUNNING:
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
  break;
  }
}

void mousePressed () {
    colClicked = mouseX / (int) PIECE_W ;
    grid.makeMove(colClicked);
}
