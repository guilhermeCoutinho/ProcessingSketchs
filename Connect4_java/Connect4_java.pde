Maxim maxim;
AudioPlayer music;
AudioPlayer chips;
AudioPlayer win;
AudioPlayer lose;
private static final int ROWS = 6;
private static final int COLS = 7;

private static final int END_GAME_ITERATIONS = 10;

private static final int MENU = 1;
private static final int AJUDA = MENU+1;
private static final int GAME_DETAILS = AJUDA+1;
private static final int GAME_RUNNING = GAME_DETAILS + 1;
private static final int GAME_FINISHED = GAME_RUNNING + 1;
private static final int SHOW_RESULTS = GAME_FINISHED + 1;

private final static int BLANK = 0;
private final static int BLACK = 1;
private final static int ORANGE = 2;
private final static int BLUE = 3;

private static final int EASY_GAME = 1 ;
private static final int MEDIUM_GAME = 2 ;
private static final int HARD_GAME = 3 ;

private static float PIECE_H, PIECE_W;
private static float GRID_H, GRID_W;

private Computer pc;

private static final int VS_MACHINE = 0;
private static final int VS_PLAYER = VS_MACHINE + 1;

private int selectedGameMode = VS_MACHINE;
private int selectedDifficulty = EASY_GAME;

private int colClicked;
private int gameStage;
private int colorChoice = ORANGE;
private int winner = BLANK;
private int bIterator;
private int endGameIterations = 0;
private Grid grid;
private boolean []paintBlue = new boolean[] {
  true, true, true, true
};
private boolean drawGameBackground = true;
private boolean drawGameDetailsBackground = true;
private boolean drawMenuBackground = true;
private boolean drawWinnerBackground = true;
private boolean computerTurn = false;
private boolean soundPlayed = false;

private static final color TEXT_OUTER_COLOR = #E8BE23;
private static final color FILL_COLOR = 70;

private float marginW;
private float marginH;
private float distanceBetweenRects;
private float rectW;
private float rectH;
private float rectVsPlayerX;
private float rectVsPlayerY;
private float rectVsMachineX;
private float rectVsMachineY;
private float rectEasyX;
private float rectEasyY;
private float rectMediumX;
private float rectMediumY;
private float rectHardX;
private float rectHardY;
private float rectOrangeX;
private float rectOrangeY;
private float rectBlackX;
private float rectBlackY;
private float rectStartGameX;
private float rectStartGameY;
private float rectBackGameX;
private float rectBackGameY;


void setup () {

  size(displayWidth, displayHeight);

  //size(240, 320);
  size(700,600);
  GRID_H = height;
  GRID_W = width;
  marginW = width/25;
  marginH = height/20;
  
  maxim = new Maxim(this);
  music = maxim.loadFile("music.wav");
  chips = maxim.loadFile("chips.wav");
  win = maxim.loadFile("win.wav");
  lose = maxim.loadFile("lose.wav");
  
  music.play();
  chips.setLooping(false);
  win.setLooping(false);
  lose.setLooping(false);

  if (GRID_H/6 < GRID_W/7 ) 
    GRID_W = GRID_H;
  else if (GRID_W/7 < GRID_H/6) 
    GRID_H = GRID_W;

  PIECE_H = GRID_H / ROWS;
  PIECE_W = GRID_W / COLS;
  gameStage = MENU;
}

void draw () {  

  switch (gameStage) {
  case MENU:

    if (drawMenuBackground) {
      drawColorfullBackgroundStaticFast();
      drawMenuBackground = false;
    }
    drawMenu();
    break;
  case AJUDA:
    drawAjuda();
    break;
  case GAME_DETAILS:
    drawGameDetails();
    break;

  case GAME_RUNNING:
    if (drawGameBackground) {
      drawColorfullBackgroundStaticFast();
      drawGameBackground = false;
    }
    drawGrid();
    if (grid.orangeWins()) {
      winner = ORANGE;
      gameStage = GAME_FINISHED;
    } else if (grid.blackWins()) {
      winner = BLACK;
      gameStage = GAME_FINISHED;
    }
    if (computerTurn && gameStage == GAME_RUNNING) {
      computerMakeMove();
      computerTurn = false;
    }
    break;
  case GAME_FINISHED :
    drawGrid();
    if (endGameIterations == END_GAME_ITERATIONS ) {
      gameStage = SHOW_RESULTS;
    }
    endGameIterations ++;
    break;
  case SHOW_RESULTS:
    showResults();
    break;
  }
}

void drawMenu () {

  rectMode(CENTER);
 
  fill(FILL_COLOR);
  rect(width/2, height/7, width/2+2, height/7+4, 7);
  rect(width/2, 3*height/7, width/2+4, height/7+4, 7);
  rect(width/2, 5*height/7, width/2+4, height/7+4, 7);
  fill(TEXT_OUTER_COLOR);
  rect(width/2, height/7, width/2, height/7, 7);
  rect(width/2, 3*height/7, width/2, height/7, 7);
  rect(width/2, 5*height/7, width/2, height/7, 7);
  fill(FILL_COLOR);
  rect(width/2, height/7, width/2-4, height/7-4, 7);
  rect(width/2, 3*height/7, width/2-4, height/7-4, 7);
  rect(width/2, 5*height/7, width/2-4, height/7-4, 7);

  textSize(width/15);
  fill(TEXT_OUTER_COLOR);
  textAlign(CENTER);
  text("PLAY", width/2, height/7 + height/38);
  text("HELP", width/2, 3*height/7 + height/38 );
  text("EXIT", width/2, 5*height/7 + height/38);
  rectMode(CORNER);
  textAlign(LEFT);
}

void drawAjuda() {
  rectMode(CENTER);
  rectMode(CENTER);
  fill(FILL_COLOR);
  stroke(TEXT_OUTER_COLOR);
  strokeWeight(3);
  rect (width/2, 3*height/8, width/2 + width/10, 5*height/8, 7);
  rect(3*width/4 - width/50, 3*height/8 - 5*height/17, GRID_W/14, GRID_H/12, 5);
  textAlign(LEFT);
  textSize(height/25);
  fill(TEXT_OUTER_COLOR);
  text ("To win the game, all you have to do is have 4 alligned pieces,"
    + "either on horizontal, vertical or diagonal. And don't let your opponent do the same !", width/2, 3*height/8, width/2 - width/20, 5*height/8);
  textAlign(CENTER);
  fill(255, 0, 0);
  text("X", 3*width/4 - width/50, 3*height/8 - 5*height/17 + height/90  );
  textAlign(LEFT);
}


void showResults () {
  // drawGrid();
  distanceBetweenRects = height/8;
  rectMode(CENTER);
  textAlign(CENTER);
  noStroke();
  fill(0);
  rect(width/2, height/2, width/2, height/7, 7);
  rect(width/2, 9*height/10, width - marginW, height/10, 7);
  rect(width/2, 9*height/10-distanceBetweenRects, width - marginW, height/10, 7 );
  fill(TEXT_OUTER_COLOR);
  rect(width/2, height/2, width/2-2, height/7-2, 7);
  rect(width/2, 9*height/10, width-2 - marginW, height/10-2, 7);
  rect(width/2, 9*height/10-distanceBetweenRects, width-2 - marginW, height/10-2, 7 );
  fill(FILL_COLOR);
  rect(width/2, height/2, width/2-8, height/7-8, 7);
  rect(width/2, 9*height/10, width-8-marginW, height/10-8, 7);
  rect(width/2, 9*height/10-distanceBetweenRects, width-8 - marginW, height/10-8, 7 );
  fill(TEXT_OUTER_COLOR);
  textSize(GRID_H/15);

  if (!soundPlayed) {
    if (winner == colorChoice ) {
      win.play();
    }else {
      lose.play();
    }
    soundPlayed = true;
  }
  if (winner == BLACK) {
    text("BLACK WINS", width/2, height/2 + height/55);
  } else if (winner == ORANGE ) {
    text("ORANGE WINS", width/2, height/2 + height/55);
  } else if (winner == BLANK ) {
    text("DRAW", width/2, height/2 + height/55);
  }
  text("PLAY AGAIN", width/2, 9*height/10-distanceBetweenRects + height/55);
  text("MENU", width/2, 9*height/10 + height/55);

  textAlign(LEFT);
  rectMode(CORNER);
}

void drawGameDetails() {
  drawColorfullBackgroundStaticFast();
  marginW = width/25;
  marginH = height/20;
  distanceBetweenRects = height/20;
  rectW = width/2 - marginW * 2;
  rectH = height/5 - marginH * 2;
  rectVsPlayerX = marginW;
  rectVsPlayerY = marginH*2;
  rectVsMachineX = rectVsPlayerX;
  rectVsMachineY = rectVsPlayerY + rectH +distanceBetweenRects;
  rectEasyX = width/2 + marginW;
  rectEasyY = marginH;
  rectMediumX = rectEasyX;
  rectMediumY = rectEasyY + rectH +distanceBetweenRects;
  rectHardX = rectEasyX;
  rectHardY = rectMediumY + rectH + distanceBetweenRects;
  rectOrangeX = marginW;
  rectOrangeY = height/2 + marginH;
  rectBlackX = width/2 + marginW;
  rectBlackY = rectOrangeY;
  rectBackGameX = marginW;
  rectBackGameY = height - marginH - rectH;
  rectStartGameX = width/2 + rectBackGameX ;
  rectStartGameY = rectBackGameY;

  stroke(255);
  strokeWeight (1);
  line(width/2, height/2, width/2, height - 2* marginH - rectH );
  line(0 + marginW, height/2, width - marginW, height /2);

  stroke(TEXT_OUTER_COLOR);  
  strokeWeight(0);
  fill(FILL_COLOR);
  rect (rectVsPlayerX, rectVsPlayerY, rectW, rectH, 7 );
  rect (rectVsMachineX, rectVsMachineY, rectW, rectH, 7);
  rect (rectEasyX, rectEasyY, rectW, rectH, 7);
  rect (rectMediumX, rectMediumY, rectW, rectH, 7);
  rect (rectHardX, rectHardY, rectW, rectH, 7);

  fill(0);
  rect (rectBlackX, rectBlackY, rectW, rectH, 7);

  strokeWeight(height/70);
  switch (selectedGameMode) {
  case VS_PLAYER :
    rect (rectVsPlayerX, rectVsPlayerY, rectW, rectH, 7 );
    break;
  case VS_MACHINE:
    rect (rectVsMachineX, rectVsMachineY, rectW, rectH, 7);
    line (rectVsMachineX + rectW, rectVsMachineY + rectH/2, width/2, rectVsMachineY + rectH/2);
    switch (selectedDifficulty) {
    case EASY_GAME:
      rect (rectEasyX, rectEasyY, rectW, rectH, 7);
      line (width/2, rectVsMachineY + rectH/2, width/2, rectEasyY+rectH/2);
      line (width/2, rectEasyY+rectH/2, rectEasyX, rectEasyY+rectH/2);
      break;
    case MEDIUM_GAME:
      rect (rectMediumX, rectMediumY, rectW, rectH, 7);
      line (width/2, rectVsMachineY + rectH/2, width/2, rectMediumY+rectH/2);
      line (width/2, rectMediumY+rectH/2, rectMediumX, rectMediumY+rectH/2);
      break;
    case HARD_GAME:
      rect (rectHardX, rectHardY, rectW, rectH, 7);
      line (width/2, rectVsMachineY + rectH/2, width/2, rectHardY+rectH/2);
      line (width/2, rectHardY+rectH/2, rectHardX, rectHardY+rectH/2);
      break;
    } 


    break;
  }

  strokeWeight(height/50);
  switch (colorChoice) {
  case ORANGE:
    rect (rectOrangeX, rectOrangeY, rectW, rectH, 7);
    break;
  case BLACK:
    rect (rectBlackX, rectBlackY, rectW, rectH, 7);
    strokeWeight(0);
    break;
  }

  fill (#FF9A03);
  rect (rectOrangeX, rectOrangeY, rectW, rectH, 7);

  strokeWeight(height/70);
  fill(FILL_COLOR);
  rect (rectStartGameX, rectStartGameY, rectW, rectH, 7);
  rect (rectBackGameX, rectBackGameY, rectW, rectH, 7);



  fill (TEXT_OUTER_COLOR);
  textAlign (CENTER);
  textSize(height/20);
  text ("VS player", rectVsPlayerX + rectW/2, rectVsPlayerY + rectH / 2 + height / 40);
  text ("VS machine", rectVsMachineX + rectW/2, rectVsMachineY + rectH/2 + height / 40);
  text ("Easy", rectEasyX + rectW/2, rectEasyY + rectH/2 + height/40);
  text ("Medium", rectMediumX + rectW/2, rectMediumY + rectH / 2 + height /40);
  text ("Hard", rectHardX + rectW/2, rectHardY + rectH / 2 + height /40);
  //  text ("Orange" , rectOrangeX + rectW/2 , rectOrangeY + rectH / 2 + height / 40);
  //  text ("Black" , rectBlackX + rectW/2 , rectBlackY + rectH/2 + height/40);
  text ("Back", rectBackGameX + rectW/2, rectBackGameY + rectH / 2 + height /40 );
  text ("Start", rectStartGameX + rectW/2, rectStartGameY + rectH /2 + height / 40);
}

void resetGame () {
  winner = BLANK;
  colorChoice = ORANGE;
  grid = null;
  drawMenuBackground = true;
  drawGameBackground = true;
  drawWinnerBackground = true;
  drawGameDetailsBackground = true;
  endGameIterations = 0;
  gameStage = MENU;
  computerTurn = false;
  selectedGameMode = VS_MACHINE;
  selectedDifficulty = EASY_GAME;
  soundPlayed = false;
}

void resetPlayAgain () {
  gameStage = GAME_RUNNING;
  computerTurn = false;
  drawGameBackground = true;
  drawWinnerBackground = true;
  endGameIterations = 0;
  grid = new Grid(colorChoice);
  soundPlayed = false;
}

void drawGrid () {
  strokeWeight(GRID_W/80);
  stroke(200);
  for ( float i = PIECE_H / 2; i <= GRID_H; i+= PIECE_H ) {
    for (float j = PIECE_W /2; j <= GRID_W; j+= PIECE_W) {
      int x = (int)i / (int) PIECE_H; //println("i" , i , "piece_w" , PIECE_H);
      int y = (int)j / (int) PIECE_W;

      switch (grid.getCorPiece(x, y) ) {
      case BLANK:
        fill(255);
        break;
      case ORANGE:
        fill(#FF9A03);
        break;
      case BLACK:
        fill(0);
        break;
      case BLUE:
        frameRate(10);
        if (paintBlue[bIterator]) {
          fill (0, 0, 200);
        } else {
          switch(winner) {
          case BLACK: 
            fill (0);
            break;
          case ORANGE: 
            fill (#FF9A03);
            break;
          }
        }
        paintBlue[bIterator] = !paintBlue[bIterator];
        bIterator ++;
        bIterator = bIterator % 4;
        break;
      }

      ellipse (j, i, PIECE_W/2, PIECE_H/2);
    }
  }
  //stroke(0);
  for (int i = 1; i <= ROWS; i ++ ) {
    line (0, PIECE_H*i, GRID_W, PIECE_H*i);
  }

  for ( int i = 0; i <= COLS; i ++ ) {
    line (PIECE_W*i, 0, PIECE_W*i, GRID_H );
  }
}


public int inverteCores (int cor) {
  if (cor == BLACK)
    return ORANGE;
  else if (cor == ORANGE)
    return BLACK;
  else return -1;
}



void mousePressed () {
  switch(gameStage) {
  case MENU:
    if ( abs(mouseX - width/2) < width/4 && abs(mouseY - height/7)<height/14 ) {
      gameStage = GAME_DETAILS;
    } else if ( abs(mouseX - width/2) < width/4 && abs(mouseY - 3*height/7)<height/14 ) {
      gameStage = AJUDA;
    } else if ( abs(mouseX - width/2) < width/4 && abs(mouseY - 5*height/7)<height/14 ) {
      exit();
    }
    break;
  case AJUDA:
    if (abs(mouseX-(3*width/4 - width/50 ) ) < GRID_W/14/2 && abs(mouseY - (3*height/8 - 5*height/17) ) < GRID_H/12/2 ) {
      background(200);
      drawColorfullBackgroundStaticFast();
      gameStage = MENU;
    }
    break;
  case GAME_DETAILS:


    if ( mouseX > rectVsPlayerX && mouseX < rectVsPlayerX + rectW && mouseY > rectVsPlayerY && mouseY < rectVsPlayerY + rectH ) {
      selectedGameMode = VS_PLAYER;
    } else if ( mouseX > rectVsMachineX && mouseX < rectVsMachineX + rectW && mouseY > rectVsMachineY && mouseY < rectVsMachineY + rectH) {
      selectedGameMode = VS_MACHINE;
    }
    if (selectedGameMode == VS_MACHINE ) {
      if (mouseX > rectEasyX && mouseX < rectEasyX + rectW && mouseY > rectEasyY && mouseY < rectEasyY + rectH ) {
        selectedDifficulty = EASY_GAME;
      } else if (mouseX > rectMediumX && mouseX < rectMediumX + rectW && mouseY > rectMediumY && mouseY < rectMediumY + rectH ) {
        selectedDifficulty = MEDIUM_GAME;
      } else if (mouseX > rectHardX && mouseX < rectHardX + rectW && mouseY > rectHardY && mouseY < rectHardY + rectH ) {
        selectedDifficulty = HARD_GAME;
      }
    }

    if (mouseX > rectOrangeX && mouseX < rectOrangeX + rectW && mouseY > rectOrangeY && mouseY < rectOrangeY + rectH ) {
      colorChoice = ORANGE;
    } else if (mouseX > rectBlackX && mouseX < rectBlackX + rectW && mouseY > rectBlackY && mouseY < rectBlackY + rectH ) {
      colorChoice = BLACK;
    }


    if (mouseX > rectStartGameX && mouseX < rectStartGameX + rectW && mouseY > rectStartGameY && mouseY < rectStartGameY + rectH ) {
      grid = new Grid (colorChoice);
      gameStage = GAME_RUNNING;
      if (selectedGameMode == VS_MACHINE ) {
        pc = new Computer (colorChoice, selectedDifficulty);
      }
      println(selectedDifficulty);
      
      
    } else if (mouseX > rectBackGameX && mouseX < rectBackGameX + rectW && mouseY > rectBackGameY && mouseY < rectBackGameY + rectH ) {
      gameStage = MENU;
      resetGame();
    }
    break;

  case GAME_RUNNING:
    colClicked = mouseX / (int) PIECE_W ;
    if (selectedGameMode == VS_MACHINE ) {
      if (colorChoice == grid.currPlayer.getCor() ) {
        if (mouseY<GRID_H && mouseX < GRID_W) {
          if (grid.makeMove(colClicked)) {
            chips.play();
            if (grid.fullGrid()) {
              gameStage = GAME_FINISHED;
            } else computerTurn = true;
          }
        }
      }
    } else if (selectedGameMode == VS_PLAYER) {
      if (mouseY<GRID_H && mouseX < GRID_W) {
        if (grid.makeMove(colClicked)) {
          chips.play();
          if (grid.fullGrid()) {
            gameStage = GAME_FINISHED;
          }
        }
      }
    }
    break;
  case SHOW_RESULTS: 
    if ( abs (mouseY - 9*height/10) < height/20 ) {
      resetGame();
      //  rect(width/2, 9*height/10-distanceBetweenRects , width-8 - marginW , height/10-8 , 7 );
    } else if ( abs (mouseY - (9*height/10 - distanceBetweenRects) ) < height/20  )  {
      resetPlayAgain();
    }
    break;
  }
}

void computerMakeMove () {
  
  grid.makeMove(pc.makeMove(grid));
  if (grid.fullGrid()) {
    gameStage = GAME_FINISHED;
  }
  chips.play();
}

