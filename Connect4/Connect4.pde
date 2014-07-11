private static final int ROWS = 6;
private static final int COLS = 7;

private static final int END_GAME_ITERATIONS = 10;

private static final int MENU = 1;
private static final int AJUDA = 2;
private static final int COLOR_CHOOSER = 3;
private static final int GAME_RUNNING = 4;
private static final int GAME_FINISHED = 5;
private static final int SHOW_WINNER = 6;

private static float PIECE_H , PIECE_W;
private static float GRID_H , GRID_W;

private int colClicked;
private int gameStage;
private int colorChoice;
private int winner = BLANK;
private int bIterator;
private int endGameIterations = 0;
private Grid grid;
private boolean []paintBlue = new boolean[] {true , true , true , true};
private boolean drawGameBackground = true;
private boolean drawMenuBackground = true;
private boolean drawWinnerBackground = true;


void setup ()  {
  size(displayWidth,displayHeight);
 
  size(240,320);
  GRID_H = height;
  GRID_W = width;
  
  if (GRID_H/6 < GRID_W/7 ) 
    GRID_W = GRID_H;
  else if (GRID_W/7 < GRID_H/6) 
    GRID_H = GRID_W;
  
  PIECE_H = GRID_H / ROWS;
  PIECE_W = GRID_W / COLS;
  gameStage = MENU;
  //frameRate(1000);
}

void draw () {  
  
  switch (gameStage) {
    case MENU:
      if (drawMenuBackground) {
        drawGrayInterferenceBackground();
        drawMenuBackground = false;
      }
      drawMenu();
    break;
    case COLOR_CHOOSER:
     drawColorChooser();
    break;
   
    case GAME_RUNNING:
        if (drawGameBackground) {
          drawColorfullBackgroundStatic();
          drawGameBackground = false;
        }
        drawGrid();
        if (winner != BLANK ) {
          gameStage = GAME_FINISHED;
        }
    break;
    case GAME_FINISHED :
      drawGrid();
      if (endGameIterations == END_GAME_ITERATIONS ){
        gameStage = SHOW_WINNER;
      }
      endGameIterations ++;
    break;
    case SHOW_WINNER:
         showWinner();
    break;
  }
}

void drawMenu () {

  rectMode(CENTER);
  fill(#FA303D);
  stroke(#E8BE23);
  strokeWeight(5);
  rect(width/2,height/7,width/2,height/7,7);
  rect(width/2,3*height/7,width/2,height/7,7);
  rect(width/2,5*height/7,width/2,height/7,7);
  textSize(width/15);
  fill(#E8BE23);
  textAlign(CENTER);
  text("PLAY" , width/2 , height/7 + height/38);
  text("HELP" , width/2 , 3*height/7 + height/38 );
  text("EXIT" , width/2 , 5*height/7 + height/38);
  rectMode(CORNER);
  textAlign(LEFT);
}

void showWinner () {
   drawGrid();
   rectMode(CENTER);
   textAlign(CENTER);
   noStroke();
   if (winner == BLACK){   
     fill(#E8BE23);
     rect(width/2,height/2,width/2,height/7,7);
     rect(width/2,9*height/10,width,height/10,7);
     fill(70);
     rect(width/2,height/2,width/2-4,height/7-4,7);
     rect(width/2,9*height/10,width-4,height/10-4,7);

     fill(#E8BE23);
     rect(width/2,height/2,width/2-16,height/7-16,7);
     rect(width/2,9*height/10,width-16,height/10-16,7);
     fill(70);
     textSize(width/15);
     text("BLACK WINS",width/2,height/2 + height/55);
     text("MENU",width/2,9*height/10 + height/55);
   }else {
     fill(0);
     rect(width/2,height/2,width/2,height/7,7);
     rect(width/2,9*height/10,width,height/10,7);
     fill(#E8BE23);
     rect(width/2,height/2,width/2-2,height/7-2,7);
     rect(width/2,9*height/10,width-2,height/10-2,7);
     fill(70);
     rect(width/2,height/2,width/2-8,height/7-8,7);
     rect(width/2,9*height/10,width-8,height/10-8,7);
     fill(#E8BE23);
     textSize(width/15);
     text("ORANGE WINS",width/2,height/2 + height/55);
     text("MENU",width/2,9*height/10 + height/55);
   }
   
   textAlign(LEFT);
   rectMode(CORNER);
}

void drawColorChooser(){
    textSize(width/21);
     fill(#FF9A03);
     rect(0,0,width/2,height);
     fill(0);
     rect(width/2,0,width/2,height);
     text("ORANGE" , width/4,height/2);
     fill(#FF9A03);
     text("BLACK" , 3*width/4 , height/2 );
     stroke(255);strokeWeight(width/70);
     line(width/2 , 0 , width/2 , height );
}

void resetGame () {
  winner = BLANK;
  grid = null;
  drawMenuBackground = true;
  drawGameBackground = true;
  drawWinnerBackground = true;
  endGameIterations = 0;
  gameStage = MENU;
}

void drawGrid () {
      
      strokeWeight(GRID_W/80);
      stroke(200);
      for ( float i = PIECE_H / 2 ; i <= GRID_H ; i+= PIECE_H ) {
        for (float j = PIECE_W /2 ; j <= GRID_W ; j+= PIECE_W){
          int x = (int)i / (int) PIECE_H; //println("i" , i , "piece_w" , PIECE_H);
          int y = (int)j / (int) PIECE_W;
          
          switch (grid.getCorPiece(x,y) ) {
            case BLANK:fill(255);
            break;
            case ORANGE:fill(#FF9A03);
            break;
            case BLACK:fill(0);
            break;
            case BLUE:
                frameRate(10);
              if (paintBlue[bIterator]){
                fill (0,0,200);
              }else{
                switch(winner){
                  case BLACK: fill (0);
                  break;
                  case ORANGE: fill (#FF9A03);
                  break;
                }
              }
              paintBlue[bIterator] = !paintBlue[bIterator];
              bIterator ++;
              bIterator = bIterator % 4;
            break;
          }
    
          ellipse (j , i , PIECE_W/2 , PIECE_H/2);
        }
      }
      //stroke(0);
      for (int i = 1 ; i <= ROWS ; i ++ ) {
        line (0,PIECE_H*i , GRID_W , PIECE_H*i);
      }
     
      for ( int i = 0 ; i <= COLS ; i ++ ) {
        line (PIECE_W*i , 0 , PIECE_W*i , GRID_H );
      }
}

void mousePressed () {
  switch(gameStage) {
    case MENU:
        if ( abs(mouseX - width/2) < width/4 && abs(mouseY - height/7)<height/14 ) {
          gameStage = COLOR_CHOOSER;
        }else if ( abs(mouseX - width/2) < width/4 && abs(mouseY - 3*height/7)<height/14 ) {
          println("ajuda");
        }else if ( abs(mouseX - width/2) < width/4 && abs(mouseY - 5*height/7)<height/14 ) {
          exit();
        }
    break;
    case COLOR_CHOOSER:
       if ( mouseX < width / 2 ) grid = new Grid (BLACK);
       else grid = new Grid (ORANGE);
       gameStage = GAME_RUNNING;
    break;
    case GAME_RUNNING:
       colClicked = mouseX / (int) PIECE_W ;
       if (mouseY<GRID_H && mouseX < GRID_W){
         grid.makeMove(colClicked);
       }
    break;
    case SHOW_WINNER: 
      if ( abs (mouseY - 9*height/10) < height/20 ){
        resetGame();
      }
    break;
  }
}
