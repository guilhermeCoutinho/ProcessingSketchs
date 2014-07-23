package processing.test.connect4;

import java.io.BufferedInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

import processing.core.PApplet;
import android.content.res.AssetFileDescriptor;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;

public class Connect4 extends PApplet {

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

private static final int TEXT_OUTER_COLOR = 0xffE8BE23;
private static final int FILL_COLOR = 70;

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


public void setup () {

 

  //size(240, 320);
  // size(700,600);
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

public void draw () {  

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

public void drawMenu () {

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

public void drawAjuda() {
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


public void showResults () {
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

public void drawGameDetails() {
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

  fill (0xffFF9A03);
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

public void resetGame () {
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

public void resetPlayAgain () {
  gameStage = GAME_RUNNING;
  computerTurn = false;
  drawGameBackground = true;
  drawWinnerBackground = true;
  endGameIterations = 0;
  grid = new Grid(colorChoice);
  soundPlayed = false;
}

public void drawGrid () {
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
        fill(0xffFF9A03);
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
            fill (0xffFF9A03);
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



public void mousePressed () {
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

public void computerMakeMove () {
  
  grid.makeMove(pc.makeMove(grid));
  if (grid.fullGrid()) {
    gameStage = GAME_FINISHED;
  }
  chips.play();
}



public class Computer {
  public int difficulty ;
  public int cor;
  private Grid auxGrid;
  private Grid originalGrid;
  int pcMove;
  private boolean []allowedMoves = new boolean[7];
  private boolean []forbiddenMoves = new boolean[7];
  public boolean computerChoose;
  
  
  public Computer (int cor , int difficulty) {
    this.cor = cor;
    this.difficulty = difficulty;
  }

  public int makeMove (Grid grid) {
   // println ("----------------------NEW MOVE COMPUTER---------------------");
    originalGrid = grid;
    computerChoose = false;
    computeForbiddenMoves();
    initializeAllowedMoves();
   // println("checkPossibleMoves call");
    checkPossibleMoves();  
    if ( !computerChoose){
   //   println("makeRandomMove call");
      makeRandomMove();
    //  println("RANDOM MOVE DID" , pcMove );  
  }
  //  println ("RETURN PC DID " , pcMove );
    return  ( pcMove );
  }

  public void computeForbiddenMoves() {
    for ( int i= 0 ; i < 7 ; i++){
      auxGrid = new Grid ( originalGrid.getCurrPlayer().getCor() );
      originalGrid.createCopy(auxGrid); 
      if (!auxGrid.makeMove(i)) {
        forbiddenMoves[i] = true;
      }else forbiddenMoves[i] = false;
    }
  }


  public void initializeAllowedMoves () {
    for (int i = 0 ; i < 7 ; i++ ) {
       allowedMoves[i] = true;
    }
  }

  public void printMoves (boolean [] b) {
    for ( int i= 0 ; i < 7 ; i ++ ){
    //  print(i ,b[i] , " ");
    }println();
  }


  public boolean allAllowedMovesAreForbidden () {
    int countAllowedMoves = 0 , countAreForbidden = 0;
    boolean theyAreForbidden = false;
    
    for ( int i = 0 ; i < 7 ; i ++ ) {
      if (allowedMoves[i]){
        countAllowedMoves++;
      }
    }
    for (int i = 0 ; i < 7 ; i++) {
      if (!allowedMoves[i] && forbiddenMoves[i] ) {
        countAreForbidden = 0;
      }
    }
    
    return ( countAllowedMoves == countAreForbidden );
    
  }


  public void makeRandomMove() {
    println("ALLOWED MOVES");
    printMoves(allowedMoves);
    println("FORBIDDEN MOVES");
    printMoves(forbiddenMoves);
 //   println("ALL ALLOWED MOVES ARE FORBIDDEN ? " , allAllowedMovesAreForbidden());
    
    if ( !allAllowedMovesAreForbidden() ) {
      while(true) {
        pcMove = (int) random (0,7);
        if ( allowedMoves[pcMove] && !forbiddenMoves[pcMove] )
          break;
      }
    }
    else {
      while(true) {
        pcMove = (int) random (0,7);
        if ( !forbiddenMoves[pcMove]  )
          break;
      }
    }
  }


  public void checkPossibleMoves () {
    
    println("\n\n---new Iteration POSSIBLE MOVES-----------");
    println("--original--");
    originalGrid.printBoard();
    for ( int i = 0 ; i < 7 ; i ++ ) {
      auxGrid = new Grid ( originalGrid.getCurrPlayer().getCor() );
      originalGrid.createCopy(auxGrid); 
      //println("--aux--");
      //auxGrid.printBoard();
    //  println("makeMove(" , i , ")");
      auxGrid.makeMove(i);
     // println("--BLACK aux AfterMove--");
      auxGrid.printBoard();
      if (auxGrid.checkWin()) {
        pcMove = i;
        computerChoose = true;
        break;
      }
      if (difficulty != EASY_GAME ) {
        auxGrid.makeMove(i);
     //   println("--GRID 1 MOVE AHEAD--");
        auxGrid.printBoard();
        if (auxGrid.checkWin() ){
        //  println("ALLOWED MOVES[",i,"] UPDATED ! ITS FALSE NOW");
          allowedMoves[i] = false;
        }
        
      }
      
      auxGrid = new Grid ( inverteCores( originalGrid.getCurrPlayer().getCor() ) );
      originalGrid.createCopy(auxGrid);
      auxGrid.makeMove(i);
     // println("--ORANGE aux AfterMove--");
      auxGrid.printBoard();
      if (auxGrid.checkWin()) {
        computerChoose = true;
        pcMove = i;
        break;
      }
      if (difficulty != EASY_GAME ) {
        auxGrid.makeMove(i);
      //  println("--GRID 2 MOVE AHEAD--");
        auxGrid.printBoard();
        if (auxGrid.checkWin() ){
      //    println("ALLOWED MOVES[",i,"] UPDATED ! ITS FALSE NOW");
          allowedMoves[i] = false;
        }
        
      }
    }
  //  println("saiu do for");

  }
  
}


public class Grid {
  private Piece[][] board = new Piece[ROWS][COLS];
  private Piece currPlayer;
  private boolean orangeWins;
  private boolean blackWins;
  private int countB = 0 , countO = 0;
  private int [] I = new int[4];
  private int [] J = new int[4];


  public void createCopy (Grid newGrid) {
    for ( int i = 0 ; i < ROWS ; i++ ){
      for (int j = 0 ; j < COLS ; j++) {
        newGrid.getBoard()[i][j].setCor( this.board[i][j].getCor() );
      }
    }
  
  }

  public void printBoard() {
   for ( int i = 0 ; i < ROWS ; i++ ){
      for (int j = 0 ; j < COLS ; j++) {
       // print(board[i][j].getCor() , " ");
      }//println();
    }
  }

  public Piece[][] getBoard () {
    return board;
  }

  public Grid (int cor) {
    reset();
    currPlayer = new Piece (cor);
  }

  public Piece getCurrPlayer () {
    return currPlayer;
  }
  
  public void setCurrPlayer(int cor) {
    currPlayer.setCor(cor);
  }
  
  public int getCorPiece ( int i , int j ) {
    return board[i][j].getCor();
  }

  public void reset () {
    for (int i = 0 ; i < ROWS ; i ++ ) {
      for ( int j =0 ; j< COLS ; j++ ) {
        board[i][j] = new Piece(BLANK);
      }
    }
    orangeWins = false;
    blackWins = false;
    countB = 0;
    countO = 0;
  }

  public boolean fullGrid () {
    boolean fullGrid = true;
    for (int i = 0 ; i < 7 ; i++ ) {
      if (board[0][i].getCor() == BLANK ) {
        fullGrid = false;
      }
    }
    return fullGrid;
  }

  public boolean checkWin() {
  //  println("-------------------------CHECK WIN VERTICAL\n\n\n");
    checkWinVer();
 //   println("-------------------------CHECK WIN HORIZONTAL\n\n\n");
    checkWinHor();
 //   println("-------------------------CHECK WIN DIAGONAL\n\n\n");
    checkWinDiag();
    return orangeWins || blackWins;
}

  public boolean blackWins(){
    return blackWins;
  }

  public boolean orangeWins(){
    return orangeWins;
  }

  private void paintWinner () {
    for (int i = 0 ; i < 4 ; i++) {
      board[I[i]][J[i]].setCor(BLUE);
    }
  }

  private void checkWinVer () {
    for ( int i = 0 ; i < COLS ; i++ ) {
      for (int j = 0; j < ROWS; j++) 
        if( findWin(j,i) ) break;
      countO = 0;countB = 0;
    }
    countO = 0;countB = 0;
  }
  
  private void checkWinHor () {
    for ( int i = 0 ; i < ROWS ;i ++ ) {
      for ( int j = 0 ; j < COLS ; j ++) 
         if (findWin(i,j) ) break;
      countO = 0;countB = 0;
    }
    countO = 0;countB = 0;
  }

  private void checkSecondaryDiagonal (int i , int j) {
    for ( ; i>= 0 && j < COLS ; i--,j++) if (findWin(i,j) ) break;
    countO = 0;countB = 0;
  }
  
  private void checkPrincipalDiagonal ( int i , int j ) {
    for ( ; i < ROWS && j < COLS ; i++ , j++) if (findWin(i,j) ) break;
    countO = 0;countB = 0;
  }
 
  private void checkWinDiag () {
    checkSecondaryDiagonal(3,0);
    checkSecondaryDiagonal(4,0);
    checkSecondaryDiagonal(5,0);
    checkSecondaryDiagonal(5,1);
    checkSecondaryDiagonal(5,2);
    checkSecondaryDiagonal(5,3);
    
    checkPrincipalDiagonal(2,0);
    checkPrincipalDiagonal(1,0);
    checkPrincipalDiagonal(0,0);
    checkPrincipalDiagonal(0,1);
    checkPrincipalDiagonal(0,2);
    checkPrincipalDiagonal(0,3);
      
}

  private boolean findWin (int i, int j) {
 //   println("i , j = " , i , j ) ;
 //   println("0 - countBcountO " , countB ,countO);
    if (board[i][j].getCor() == BLANK ) {
      countB = 0;
      countO = 0;
 //   println("1 - countBcountO " , countB ,countO);
      }

    else if (board[i][j].getCor() == BLACK ) {
      I[countB] = i;
      J[countB] = j;
      countB ++;
      countO = 0;
 //     println("2 - countBcountO " , countB ,countO);
      if (countB == 4 ) {
        blackWins = true;
        paintWinner();
        } 
      }
    else if (board[i][j].getCor() == ORANGE ) {
      I[countO] = i;
      J[countO] = j;
    //  println("3 - countBcountO " , countB ,countO);
      countO ++ ;
      countB = 0;
      if (countO == 4 ) {
        orangeWins = true;
        paintWinner();
        }
      }
    return blackWins || orangeWins;
  }

  private void togglePlayer () {
    if (currPlayer.getCor() == BLACK ) {currPlayer.setCor(ORANGE);}
    else if (currPlayer.getCor() == ORANGE) {currPlayer.setCor(BLACK);}
  }

  public boolean makeMove (int col) {
    boolean mkMove = false;

    for (int i = ROWS-1 ; i >= 0 ; i -- ) {
      //println("--i,col--",i,",",col);
      if ( board[i][col].getCor() == BLANK ) {
        mkMove = true;
        board[i][col].setCor ( currPlayer.getCor() );
        break;
      }
    }
    if (!mkMove) {println ("full column");}
  else {togglePlayer();}
  checkWin();
  return mkMove;
  }

}


private class Piece {
  private int cor;
  
  public Piece (int cor) {
    this.cor = cor;
  }
  
  public void setCor (int cor) {
    this.cor = cor;
  }
  public int getCor ( ){
    return cor;
  }
  
}
/*
The MIT License (MIT)
 
 Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies
 
 Permission is hereby granted, free of charge, to any person obtaining a copy\u2028of 
 this software and associated documentation files (the "Software"), to 
 deal\u2028in the Software without restriction, including without limitation 
 the rights\u2028to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell\u2028copies of the Software, and to permit persons to whom the 
 Software is\u2028furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included 
 in \u2028all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\u2028IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\u2028FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\u2028AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\u2028LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\u2028OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\u2028THE SOFTWARE.
 */

// putting this up in global scope for consistency with maxim.js
// eventually, this should be inside Maxim in all versions of the library...
float[] mtof = {
    0f, 8.661957f, 9.177024f, 9.722718f, 10.3f, 10.913383f, 11.562325f, 12.25f, 12.978271f, 13.75f, 14.567617f, 15.433853f, 16.351599f, 17.323914f, 18.354048f, 19.445436f, 20.601723f, 21.826765f, 23.124651f, 24.5f, 25.956543f, 27.5f, 29.135235f, 30.867706f, 32.703197f, 34.647827f, 36.708096f, 38.890873f, 41.203445f, 43.65353f, 46.249302f, 49.f, 51.913086f, 55.f, 58.27047f, 61.735413f, 65.406395f, 69.295654f, 73.416191f, 77.781746f, 82.406891f, 87.30706f, 92.498604f, 97.998856f, 103.826172f, 110.f, 116.540939f, 123.470825f, 130.81279f, 138.591309f, 146.832382f, 155.563492f, 164.813782f, 174.61412f, 184.997208f, 195.997711f, 207.652344f, 220.f, 233.081879f, 246.94165f, 261.62558f, 277.182617f, 293.664764f, 311.126984f, 329.627563f, 349.228241f, 369.994415f, 391.995422f, 415.304688f, 440.f, 466.163757f, 493.883301f, 523.25116f, 554.365234f, 587.329529f, 622.253967f, 659.255127f, 698.456482f, 739.988831f, 783.990845f, 830.609375f, 880.f, 932.327515f, 987.766602f, 1046.502319f, 1108.730469f, 1174.659058f, 1244.507935f, 1318.510254f, 1396.912964f, 1479.977661f, 1567.981689f, 1661.21875f, 1760.f, 1864.655029f, 1975.533203f, 2093.004639f, 2217.460938f, 2349.318115f, 2489.015869f, 2637.020508f, 2793.825928f, 2959.955322f, 3135.963379f, 3322.4375f, 3520.f, 3729.31f, 3951.066406f, 4186.009277f, 4434.921875f, 4698.63623f, 4978.031738f, 5274.041016f, 5587.651855f, 5919.910645f, 6271.926758f, 6644.875f, 7040.f, 7458.620117f, 7902.132812f, 8372.018555f, 8869.84375f, 9397.272461f, 9956.063477f, 10548.082031f, 11175.303711f, 11839.821289f, 12543.853516f, 13289.75f
  };








//import android.content.res.Resources;
 
 






public class Maxim {

  private float sampleRate = 44100;

  public final float[] mtof = {
    0, 8.661957f, 9.177024f, 9.722718f, 10.3f, 10.913383f, 11.562325f, 12.25f, 12.978271f, 13.75f, 14.567617f, 15.433853f, 16.351599f, 17.323914f, 18.354048f, 19.445436f, 20.601723f, 21.826765f, 23.124651f, 24.5f, 25.956543f, 27.5f, 29.135235f, 30.867706f, 32.703197f, 34.647827f, 36.708096f, 38.890873f, 41.203445f, 43.65353f, 46.249302f, 49.f, 51.913086f, 55.f, 58.27047f, 61.735413f, 65.406395f, 69.295654f, 73.416191f, 77.781746f, 82.406891f, 87.30706f, 92.498604f, 97.998856f, 103.826172f, 110.f, 116.540939f, 123.470825f, 130.81279f, 138.591309f, 146.832382f, 155.563492f, 164.813782f, 174.61412f, 184.997208f, 195.997711f, 207.652344f, 220.f, 233.081879f, 246.94165f, 261.62558f, 277.182617f, 293.664764f, 311.126984f, 329.627563f, 349.228241f, 369.994415f, 391.995422f, 415.304688f, 440.f, 466.163757f, 493.883301f, 523.25116f, 554.365234f, 587.329529f, 622.253967f, 659.255127f, 698.456482f, 739.988831f, 783.990845f, 830.609375f, 880.f, 932.327515f, 987.766602f, 1046.502319f, 1108.730469f, 1174.659058f, 1244.507935f, 1318.510254f, 1396.912964f, 1479.977661f, 1567.981689f, 1661.21875f, 1760.f, 1864.655029f, 1975.533203f, 2093.004639f, 2217.460938f, 2349.318115f, 2489.015869f, 2637.020508f, 2793.825928f, 2959.955322f, 3135.963379f, 3322.4375f, 3520.f, 3729.31f, 3951.066406f, 4186.009277f, 4434.921875f, 4698.63623f, 4978.031738f, 5274.041016f, 5587.651855f, 5919.910645f, 6271.926758f, 6644.875f, 7040.f, 7458.620117f, 7902.132812f, 8372.018555f, 8869.84375f, 9397.272461f, 9956.063477f, 10548.082031f, 11175.303711f, 11839.821289f, 12543.853516f, 13289.75f
  };

  private AndroidAudioThread audioThread;

  public Maxim (PApplet app) {
    audioThread = new AndroidAudioThread(sampleRate, 256, false);
    audioThread.start();
  }

  public float[] getPowerSpectrum() {
    return audioThread.getPowerSpectrum();
  }

  /** 
   *  load the sent file into an audio player and return it. Use
   *  this if your audio file is not too long want precision control
   *  over looping and play head position
   * @param String filename - the file to load
   * @return AudioPlayer - an audio player which can play the file
   */
  public AudioPlayer loadFile(String filename) {
    // this will load the complete audio file into memory
    AudioPlayer ap = new AudioPlayer(filename, sampleRate);
    audioThread.addAudioGenerator(ap);
    // now we need to tell the audiothread
    // to ask the audioplayer for samples
    return ap;
  }

  /**
   * Create a wavetable player object with a wavetable of the sent
   * size. Small wavetables (<128) make for a 'nastier' sound!
   * 
   */
  public WavetableSynth createWavetableSynth(int size) {
    // this will load the complete audio file into memory
    WavetableSynth ap = new WavetableSynth(size, sampleRate);
    audioThread.addAudioGenerator(ap);
    // now we need to tell the audiothread
    // to ask the audioplayer for samples
    return ap;
  }
  /**
   * Create an AudioStreamPlayer which can stream audio from the
   * internet as well as local files.  Does not provide precise
   * control over looping and playhead like AudioPlayer does.  Use this for
   * longer audio files and audio from the internet.
   */
  public AudioStreamPlayer createAudioStreamPlayer(String url) {
    AudioStreamPlayer asp = new AudioStreamPlayer(url);
    return asp;
  }
}



/**
 * This class can play audio files and includes an fx chain 
 */
public class AudioPlayer implements Synth, AudioGenerator {
  private FXChain fxChain;
  private boolean isPlaying;
  private boolean isLooping;
  private boolean analysing;
  private FFT fft;
  private int fftInd;
  private float[] fftFrame;
  private float[] powerSpectrum;

  //private float startTimeSecs;
  //private float speed;
  private int length;
  private short[] audioData;
  private float startPos;
  private float readHead;
  private float dReadHead;
  private float sampleRate;
  private float masterVolume;

  float x1, x2, y1, y2, x3, y3;

  public AudioPlayer(float sampleRate) {
    fxChain = new FXChain(sampleRate);
    this.dReadHead = 1;
    this.sampleRate = sampleRate;
    this.masterVolume = 1;
  }

  public AudioPlayer (String filename, float sampleRate) {
    //super(filename);
    this(sampleRate);
    try {
      // how long is the file in bytes?
      long byteCount = getAssets().openFd(filename).getLength();
      //System.out.println("bytes in "+filename+" "+byteCount);

      // check the format of the audio file first!
      // only accept mono 16 bit wavs
      InputStream is = getAssets().open(filename); 
      BufferedInputStream bis = new BufferedInputStream(is);

      // chop!!

      int bitDepth;
      int channels;
      boolean isPCM;
      // allows us to read up to 4 bytes at a time 
      byte[] byteBuff = new byte[4];

      // skip 20 bytes to get file format
      // (1 byte)
      bis.skip(20);
      bis.read(byteBuff, 0, 2); // read 2 so we are at 22 now
      isPCM = ((short)byteBuff[0]) == 1 ? true:false; 
      //System.out.println("File isPCM "+isPCM);

      // skip 22 bytes to get # channels
      // (1 byte)
      bis.read(byteBuff, 0, 2);// read 2 so we are at 24 now
      channels = (short)byteBuff[0];
      //System.out.println("#channels "+channels+" "+byteBuff[0]);
      // skip 24 bytes to get sampleRate
      // (32 bit int)
      bis.read(byteBuff, 0, 4); // read 4 so now we are at 28
      sampleRate = bytesToInt(byteBuff, 4);
      //System.out.println("Sample rate "+sampleRate);
      // skip 34 bytes to get bits per sample
      // (1 byte)
      bis.skip(6); // we were at 28...
      bis.read(byteBuff, 0, 2);// read 2 so we are at 36 now
      bitDepth = (short)byteBuff[0];
      //System.out.println("bit depth "+bitDepth);
      // convert to word count...
      bitDepth /= 8;
      // now start processing the raw data
      // data starts at byte 36
      int sampleCount = (int) ((byteCount - 36) / (bitDepth * channels));
      audioData = new short[sampleCount];
      int skip = (channels -1) * bitDepth;
      int sample = 0;
      // skip a few sample as it sounds like shit
      bis.skip(bitDepth * 4);
      while (bis.available () >= (bitDepth+skip)) {
        bis.read(byteBuff, 0, bitDepth);// read 2 so we are at 36 now
        //int val = bytesToInt(byteBuff, bitDepth);
        // resample to 16 bit by casting to a short
        audioData[sample] = (short) bytesToInt(byteBuff, bitDepth);
        bis.skip(skip);
        sample ++;
      }

      float secs = (float)sample / (float)sampleRate;
      //System.out.println("Read "+sample+" samples expected "+sampleCount+" time "+secs+" secs ");      
      bis.close();


      // unchop
      readHead = 0;
      startPos = 0;
      // default to 1 sample shift per tick
      dReadHead = 1;
      isPlaying = false;
      isLooping = true;
      masterVolume = 1;
    } 
    catch (FileNotFoundException e) {

      e.printStackTrace();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  public void setAnalysing(boolean analysing_) {
    this.analysing = analysing_;
    if (analysing) {// initialise the fft
      fft = new FFT();
      fftInd = 0;
      fftFrame = new float[1024];
      powerSpectrum = new float[fftFrame.length/2];
    }
  }

  public float getAveragePower() {
    if (analysing) {
      // calc the average
      float sum = 0;
      for (int i=0;i<powerSpectrum.length;i++) {
        sum += powerSpectrum[i];
      }
      sum /= powerSpectrum.length;
      return sum;
    }
    else {
      System.out.println("call setAnalysing to enable power analysis");
      return 0;
    }
  }
  public float[] getPowerSpectrum() {
    if (analysing) {
      return powerSpectrum;
    }
    else {
      System.out.println("call setAnalysing to enable power analysis");
      return null;
    }
  }

  /** 
   *convert the sent byte array into an int. Assumes little endian byte ordering. 
   *@param bytes - the byte array containing the data
   *@param wordSizeBytes - the number of bytes to read from bytes array
   *@return int - the byte array as an int
   */
  private int bytesToInt(byte[] bytes, int wordSizeBytes) {
    int val = 0;
    for (int i=wordSizeBytes-1; i>=0; i--) {
      val <<= 8;
      val |= (int)bytes[i] & 0xFF;
    }
    return val;
  }

  /**
   * Test if this audioplayer is playing right now
   * @return true if it is playing, false otherwise
   */
  public boolean isPlaying() {
    return isPlaying;
  }

  /**
   * Set the loop mode for this audio player
   * @param looping 
   */
  public void setLooping(boolean looping) {
    isLooping = looping;
  }

  /**
   * Move the start pointer of the audio player to the sent time in ms
   * @param timeMs - the time in ms
   */
  public void cue(int timeMs) {
    //startPos = ((timeMs / 1000) * sampleRate) % audioData.length;
    //readHead = startPos;
    //System.out.println("AudioPlayer Cueing to "+timeMs);
    if (timeMs >= 0) {// ignore crazy values
      readHead = (((float)timeMs / 1000f) * sampleRate) % audioData.length;
      //System.out.println("Read head went to "+readHead);
    }
  }

  /**
   *  Set the playback speed,
   * @param speed - playback speed where 1 is normal speed, 2 is double speed
   */
  public void speed(float speed) {
    //System.out.println("setting speed to "+speed);
    dReadHead = speed;
  }

  /**
   * Set the master volume of the AudioPlayer
   */

  public void volume(float volume) {
    masterVolume = volume;
  }

  /**
   * Get the length of the audio file in samples
   * @return int - the  length of the audio file in samples
   */
  public int getLength() {
    return audioData.length;
  }
  /**
   * Get the length of the sound in ms, suitable for sending to 'cue'
   */
  public float getLengthMs() {
    return ((float) audioData.length / sampleRate * 1000f);
  }

  /**
   * Start playing the sound. 
   */
  public void play() {
    isPlaying = true;
  }

  /**
   * Stop playing the sound
   */
  public void stop() {
    isPlaying = false;
  }

  /**
   * implementation of the AudioGenerator interface
   */
  public short getSample() {
    if (!isPlaying) {
      return 0;
    }
    else {
      short sample;
      readHead += dReadHead;
      if (readHead > (audioData.length - 1)) {// got to the end
        //% (float)audioData.length;
        if (isLooping) {// back to the start for loop mode
          readHead = readHead % (float)audioData.length;
        }
        else {
          readHead = 0;
          isPlaying = false;
        }
      }

      // linear interpolation here
      // declaring these at the top...
      // easy to understand version...
      //      float x1, x2, y1, y2, x3, y3;
      x1 = floor(readHead);
      x2 = x1 + 1;
      y1 = audioData[(int)x1];
      y2 = audioData[(int) (x2 % audioData.length)];
      x3 = readHead;
      // calc 
      y3 =  y1 + ((x3 - x1) * (y2 - y1));
      y3 *= masterVolume;
      sample = fxChain.getSample((short) y3);
      if (analysing) {
        // accumulate samples for the fft
        fftFrame[fftInd] = (float)sample / 32768f;
        fftInd ++;
        if (fftInd == fftFrame.length - 1) {// got a frame
          powerSpectrum = fft.process(fftFrame, true);
          fftInd = 0;
        }
      }
      // println(audioData[(int)x1]);
      return sample;
      //return (short)y3;
      //return audioData[(int)x1];
    }
  }

  public void setAudioData(short[] audioData) {
    //println(audioData[100]);
    this.audioData = audioData;
  }

  public short[] getAudioData() {
    return audioData;
  }

  public void setDReadHead(float dReadHead) {
    this.dReadHead = dReadHead;
  }

  ///
  //the synth interface
  // 

  public void ramp(float val, float timeMs) {
    fxChain.ramp(val, timeMs);
  } 



  public void setDelayTime(float delayMs) {
    fxChain.setDelayTime( delayMs);
  }

  public void setDelayFeedback(float fb) {
    fxChain.setDelayFeedback(fb);
  }

  public void setFilter(float cutoff, float resonance) {
    fxChain.setFilter( cutoff, resonance);
  }
}

/**
 * This class can play wavetables and includes an fx chain
 */
public class WavetableSynth extends AudioPlayer {

  private short[] sine;
  private short[] saw;
  private short[] wavetable;
  private float sampleRate;

  public WavetableSynth(int size, float sampleRate) {
    super(sampleRate);
    sine = new short[size];
    for (float i = 0; i < sine.length; i++) {
      float phase;
      phase = TWO_PI / size * i;
      sine[(int)i] = (short) (sin(phase) * 32768);
    }
    saw = new short[size];
    for (float i = 0; i<saw.length; i++) {
      saw[(int)i] = (short) (i / (float)saw.length *32768);
    }

    this.sampleRate = sampleRate;
    setAudioData(saw);
    setLooping(true);
  }
  //    public short getSample() {
  //      return (short) random(0, 65536);
  //    }


  public void setFrequency(float freq) {
    if (freq > 0) {
      //System.out.println("freq freq "+freq);
      setDReadHead((float)getAudioData().length / sampleRate * freq);
    }
  }

  /** for consistency with maxim.js */
  public void waveTableSize(int size){
  }
  
  /** alias to loadWaveForm for consistency with maxim.js*/
  public void loadWaveTable(float[] wavetable_){
    loadWaveForm(wavetable_);
  }

  public void loadWaveForm(float[] wavetable_) {
    if (wavetable == null || wavetable_.length != wavetable.length) {
      // only reallocate if there is a change in length
      wavetable = new short[wavetable_.length];
    }
    for (int i=0;i<wavetable.length;i++) {
      wavetable[i] = (short) (wavetable_[i] * 32768);
    }
    setAudioData(wavetable);
  }
}

public interface Synth {
  public void volume(float volume);
  public void ramp(float val, float timeMs);  
  public void setDelayTime(float delayMs);  
  public void setDelayFeedback(float fb);  
  public void setFilter(float cutoff, float resonance);
  public void setAnalysing(boolean analysing);
  public float getAveragePower();
  public float[] getPowerSpectrum();
}

public class AndroidAudioThread extends Thread
{
  private int minSize;
  private AudioTrack track;
  private short[] bufferS;
  private float[] bufferF;
  private ArrayList audioGens;
  private boolean running;

  private FFT fft;
  private float[] fftFrame;


  public AndroidAudioThread(float samplingRate, int bufferLength) {
    this(samplingRate, bufferLength, false);
  }

  public AndroidAudioThread(float samplingRate, int bufferLength, boolean enableFFT)
  {
    audioGens = new ArrayList();
    minSize =AudioTrack.getMinBufferSize( (int)samplingRate, AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT );        
    //println();
    // note that we set the buffer just to something small
    // not to the minSize
    // setting to minSize seems to cause glitches on the delivery of audio 
    // to the sound card (i.e. ireegular delivery rate)
    bufferS = new short[bufferLength];
    bufferF = new float[bufferLength];

    track = new AudioTrack( AudioManager.STREAM_MUSIC, (int)samplingRate, 
    AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT, 
    minSize, AudioTrack.MODE_STREAM);
    track.play();

    if (enableFFT) {
      try {
        fft = new FFT();
      }
      catch(Exception e) {
        println("Error setting up the audio analyzer");
        e.printStackTrace();
      }
    }
  }

  /**
   * Returns a recent snapshot of the power spectrum as 8 bit values
   */
  public float[] getPowerSpectrum() {
    // process the last buffer that was calculated
    if (fftFrame == null) {
      fftFrame = new float[bufferS.length];
    }
    for (int i=0;i<fftFrame.length;i++) {
      fftFrame[i] = ((float) bufferS[i] / 32768f);
    }
    return fft.process(fftFrame, true);
    //return powerSpectrum;
  }

  // overidden from Thread
  public void run() {
    running = true;
    while (running) {
      //System.out.println("AudioThread : ags  "+audioGens.size());
      for (int i=0;i<bufferS.length;i++) {
        // we add up using a 32bit int
        // to prevent clipping
        int val = 0;
        if (audioGens.size() > 0) {
          for (int j=0;j<audioGens.size(); j++) {
            AudioGenerator ag = (AudioGenerator)audioGens.get(j);
            val += ag.getSample();
          }
          val /= audioGens.size();
        }
        bufferS[i] = (short) val;
      }
      // send it to the audio device!
      track.write( bufferS, 0, bufferS.length );
    }
  }

  public void addAudioGenerator(AudioGenerator ag) {
    audioGens.add(ag);
  }
}

/**
 * Implement this interface so the AudioThread can request samples from you
 */
public interface AudioGenerator {
  /** AudioThread calls this when it wants a sample */
  public short getSample();
}


public class FXChain {
  private float currentAmp;
  private float dAmp;
  private float targetAmp;
  private boolean goingUp;
  private Filter filter;

  private float[] dLine;   

  private float sampleRate;

  public FXChain(float sampleRate_) {
    sampleRate = sampleRate_;
    currentAmp = 1;
    dAmp = 0;
    // filter = new MickFilter(sampleRate);
    filter = new RLPF(sampleRate);

    filter.setFilter(sampleRate, 0.5f);
  }

  public void ramp(float val, float timeMs) {
    // calc the dAmp;
    // - change per ms
    targetAmp = val;
    dAmp = (targetAmp - currentAmp) / (timeMs / 1000 * sampleRate);
    if (targetAmp > currentAmp) {
      goingUp = true;
    }
    else {
      goingUp = false;
    }
  }


  public void setDelayTime(float delayMs) {
  }

  public void setDelayFeedback(float fb) {
  }

  public void volume(float volume) {
  }


  public short getSample(short input) {
    float in;
    in = (float) input / 32768;// -1 to 1

    in =  filter.applyFilter(in);
    if (goingUp && currentAmp < targetAmp) {
      currentAmp += dAmp;
    }
    else if (!goingUp && currentAmp > targetAmp) {
      currentAmp += dAmp;
    }  

    if (currentAmp > 1) {
      currentAmp = 1;
    }
    if (currentAmp < 0) {
      currentAmp = 0;
    }  
    in *= currentAmp;  
    return (short) (in * 32768);
  }

  public void setFilter(float f, float r) {
    filter.setFilter(f, r);
  }
}


/**
 * Represents an audio source is streamed as opposed to being completely loaded (as WavSource is)
 */
public class AudioStreamPlayer {
  /** a class from the android API*/
  private MediaPlayer mediaPlayer;
  /** a class from the android API*/
  private Visualizer viz; 
  private byte[] waveformBuffer;
  private byte[] fftBuffer;
  private byte[] powerSpectrum;

  /**
   * create a stream source from the sent url 
   */
  public AudioStreamPlayer(String url) {
    try {
      mediaPlayer = new MediaPlayer();
      //mp.setAuxEffectSendLevel(1);
      mediaPlayer.setLooping(true);

      // try to parse the URL... if that fails, we assume it
      // is a local file in the assets folder
      try {
        URL uRL = new URL(url);
        mediaPlayer.setDataSource(url);
      }
      catch (MalformedURLException eek) {
        // couldn't parse the url, assume its a local file
        AssetFileDescriptor afd = getAssets().openFd(url);
        //mp.setDataSource(afd.getFileDescriptor(),afd.getStartOffset(),afd.getLength());
        mediaPlayer.setDataSource(afd.getFileDescriptor());
        afd.close();
      }

      mediaPlayer.prepare();
      //mediaPlayer.start();
      //println("Created audio with id "+mediaPlayer.getAudioSessionId());
      viz = new Visualizer(mediaPlayer.getAudioSessionId());
      viz.setEnabled(true);
      waveformBuffer = new byte[viz.getCaptureSize()];
      fftBuffer = new byte[viz.getCaptureSize()/2];
      powerSpectrum = new byte[viz.getCaptureSize()/2];
    }
    catch (Exception e) {
      println("StreamSource could not be initialised. Check url... "+url+ " and that you have added the permission INTERNET, RECORD_AUDIO and MODIFY_AUDIO_SETTINGS to the manifest,");
      e.printStackTrace();
    }
  }

  public void play() {
    mediaPlayer.start();
  }

  public int getLengthMs() {
    return mediaPlayer.getDuration();
  }

  public void cue(float timeMs) {
    if (timeMs >= 0 && timeMs < getLengthMs()) {// ignore crazy values
      mediaPlayer.seekTo((int)timeMs);
    }
  }

  /**
   * Returns a recent snapshot of the power spectrum as 8 bit values
   */
  public byte[] getPowerSpectrum() {
    // calculate the spectrum
    viz.getFft(fftBuffer);
    short real, imag;
    for (int i=2;i<fftBuffer.length;i+=2) {
      real = (short) fftBuffer[i];
      imag = (short) fftBuffer[i+1];
      powerSpectrum[i/2] = (byte) ((real * real)  + (imag * imag));
    }
    return powerSpectrum;
  }

  /**
   * Returns a recent snapshot of the waveform being played 
   */
  public byte[] getWaveForm() {
    // retrieve the waveform
    viz.getWaveForm(waveformBuffer);
    return waveformBuffer;
  }
} 

/**
 * Use this class to retrieve data about the movement of the device
 */
public class Accelerometer implements SensorEventListener {
  private SensorManager sensorManager;
  private Sensor accelerometer;
  private float[] values;

  public Accelerometer() {
    sensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
    accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
    values = new float[3];
  }


  public float[] getValues() {
    return values;
  }

  public float getX() {
    return values[0];
  }

  public float getY() {
    return values[1];
  }

  public float getZ() {
    return values[2];
  }

  /**
   * SensorEventListener interace
   */
  public void onSensorChanged(SensorEvent event) {
    values = event.values;
    //float[] vals = event.values;
    //for (int i=0; i<vals.length;i++){
    //  println(" sensor! "+vals[i]);
    //}
  }

  /**
   * SensorEventListener interace
   */
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}

public interface Filter {
  public void setFilter(float f, float r);
  public float applyFilter(float in);
}

/** https://github.com/supercollider/supercollider/blob/master/server/plugins/FilterUGens.cpp */

public class RLPF implements Filter {
  float a0, b1, b2, y1, y2;
  float freq;
  float reson;
  float sampleRate;
  boolean changed;

  public RLPF(float sampleRate_) {
    this.sampleRate = sampleRate_;
    reset();
    this.setFilter(sampleRate / 4, 0.01f);
  }
  private void reset() {
    a0 = 0.f;
    b1 = 0.f;
    b2 = 0.f;
    y1 = 0.f;
    y2 = 0.f;
  }
  /** f is in the range 0-sampleRate/2 */
  public void setFilter(float f, float r) {
    // constrain 
    // limit to 0-1 
    f = constrain(f, 0, sampleRate/4);
    r = constrain(r, 0, 1);
    // invert so high r -> high resonance!
    r = 1-r;
    // remap to appropriate ranges
    f = map(f, 0, sampleRate/4, 30, sampleRate / 4);
    r = map(r, 0, 1, 0.005f, 2);

   // println("rlpf: f "+f+" r "+r);

    this.freq = f * TWO_PI / sampleRate;
    this.reson = r;
    changed = true;
  }

  public float applyFilter(float in) {
    float y0;
    if (changed) {
      float D = tan(freq * reson * 0.5f);
      float C = ((1.f-D)/(1.f+D));
      float cosf = cos(freq);
      b1 = (1.f + C) * cosf;
      b2 = -C;
      a0 = (1.f + C - b1) * .25f;
      changed = false;
    }
    y0 = a0 * in + b1 * y1 + b2 * y2;
    y2 = y1;
    y1 = y0;
    if (Float.isNaN(y0)) {
      reset();
    }
    return y0;
  }
}

/** https://github.com/micknoise/Maximilian/blob/master/maximilian.cpp */

class MickFilter implements Filter {

  private float f, res;
  private float cutoff, z, c, x, y, out;
  private float sampleRate;

  MickFilter(float sampleRate) {
    this.sampleRate = sampleRate;
  }

  public void setFilter(float f, float r) {
    f = constrain(f, 0, 1);
    res = constrain(r, 0, 1);
    f = map(f, 0, 1, 25, sampleRate / 4);
    r = map(r, 0, 1, 1, 25);
    this.f = f;
    this.res = r;    

    //println("mickF: f "+f+" r "+r);
  }
  public float applyFilter(float in) {
    return lores(in, f, res);
  }

  public float lores(float input, float cutoff1, float resonance) {
    //cutoff=cutoff1*0.5;
    //if (cutoff<10) cutoff=10;
    //if (cutoff>(sampleRate*0.5)) cutoff=(sampleRate*0.5);
    //if (resonance<1.) resonance = 1.;

    //if (resonance>2.4) resonance = 2.4;
    z=cos(TWO_PI*cutoff/sampleRate);
    c=2-2*z;
    float r=(sqrt(2.0f)*sqrt(-pow((z-1.0f), 3.0f))+resonance*(z-1))/(resonance*(z-1));
    x=x+(input-y)*c;
    y=y+x;
    x=x*r;
    out=y;
    return out;
  }
}


/*
 * This file is part of Beads. See http://www.beadsproject.net for all information.
 * CREDIT: This class uses portions of code taken from MPEG7AudioEnc. See readme/CREDITS.txt.
 */

/**
 * FFT performs a Fast Fourier Transform and forwards the complex data to any listeners. 
 * The complex data is a float of the form float[2][frameSize], with real and imaginary 
 * parts stored respectively.
 * 
 * @beads.category analysis
 */
public class FFT {

  /** The real part. */
  protected float[] fftReal;

  /** The imaginary part. */
  protected float[] fftImag;

  private float[] dataCopy = null;
  private float[][] features;
  private float[] powers;
  private int numFeatures;

  /**
   * Instantiates a new FFT.
   */
  public FFT() {
    features = new float[2][];
  }

  /* (non-Javadoc)
   * @see com.olliebown.beads.core.UGen#calculateBuffer()
   */
  public float[] process(float[] data, boolean direction) {
    if (powers == null) powers = new float[data.length/2];
    if (dataCopy==null || dataCopy.length!=data.length)
      dataCopy = new float[data.length];
    System.arraycopy(data, 0, dataCopy, 0, data.length);

    fft(dataCopy, dataCopy.length, direction);
    numFeatures = dataCopy.length;
    fftReal = calculateReal(dataCopy, dataCopy.length);
    fftImag = calculateImaginary(dataCopy, dataCopy.length);
    features[0] = fftReal;
    features[1] = fftImag;
    // now calc the powers
    return specToPowers(fftReal, fftImag, powers);
  }

  public float[] specToPowers(float[] real, float[] imag, float[] powers) {
    float re, im;
    double pow;
    for (int i=0;i<powers.length;i++) {
      //real = spectrum[i][j].re();
      //imag = spectrum[i][j].im();
      re = real[i];
      im = imag[i];
      powers[i] = (re*re + im * im);
      powers[i] = (float) Math.sqrt(powers[i]) / 10;
      // convert to dB
      pow = (double) powers[i];
      powers[i] = (float)(10 *  Math.log10(pow * pow)); // (-100 - 100)
      powers[i] = (powers[i] + 100) * 0.005f; // 0-1
    }
    return powers;
  }

  /**
   * The frequency corresponding to a specific bin 
   * 
   * @param samplingFrequency The Sampling Frequency of the AudioContext
   * @param blockSize The size of the block analysed
   * @param binNumber 
   */
  public  float binFrequency(float samplingFrequency, int blockSize, float binNumber)
  {    
    return binNumber*samplingFrequency/blockSize;
  }

  /**
   * Returns the average bin number corresponding to a particular frequency.
   * Note: This function returns a float. Take the Math.round() of the returned value to get an integral bin number. 
   * 
   * @param samplingFrequency The Sampling Frequency of the AudioContext
   * @param blockSize The size of the fft block
   * @param freq  The frequency
   */

  public  float binNumber(float samplingFrequency, int blockSize, float freq)
  {
    return blockSize*freq/samplingFrequency;
  }

  /** The nyquist frequency for this samplingFrequency 
   * 
   * @params samplingFrequency the sample
   */
  public  float nyquist(float samplingFrequency)
  {
    return samplingFrequency/2;
  }

  /*
   * All of the code below this line is taken from Holger Crysandt's MPEG7AudioEnc project.
   * See http://mpeg7audioenc.sourceforge.net/copyright.html for license and copyright.
   */

  /**
   * Gets the real part from the complex spectrum.
   * 
   * @param spectrum
   *            complex spectrum.
   * @param length 
   *       length of data to use.
   * 
   * @return real part of given length of complex spectrum.
   */
  protected  float[] calculateReal(float[] spectrum, int length) {
    float[] real = new float[length];
    real[0] = spectrum[0];
    real[real.length/2] = spectrum[1];
    for (int i=1, j=real.length-1; i<j; ++i, --j)
      real[j] = real[i] = spectrum[2*i];
    return real;
  }

  /**
   * Gets the imaginary part from the complex spectrum.
   * 
   * @param spectrum
   *            complex spectrum.
   * @param length 
   *       length of data to use.
   * 
   * @return imaginary part of given length of complex spectrum.
   */
  protected  float[] calculateImaginary(float[] spectrum, int length) {
    float[] imag = new float[length];
    for (int i=1, j=imag.length-1; i<j; ++i, --j)
      imag[i] = -(imag[j] = spectrum[2*i+1]);
    return imag;
  }

  /**
   * Perform FFT on data with given length, regular or inverse.
   * 
   * @param data the data
   * @param n the length
   * @param isign true for regular, false for inverse.
   */
  protected  void fft(float[] data, int n, boolean isign) {
    float c1 = 0.5f; 
    float c2, h1r, h1i, h2r, h2i;
    double wr, wi, wpr, wpi, wtemp;
    double theta = 3.141592653589793f/(n>>1);
    if (isign) {
      c2 = -.5f;
      four1(data, n>>1, true);
    } 
    else {
      c2 = .5f;
      theta = -theta;
    }
    wtemp = Math.sin(.5f*theta);
    wpr = -2.f*wtemp*wtemp;
    wpi = Math.sin(theta);
    wr = 1.f + wpr;
    wi = wpi;
    int np3 = n + 3;
    for (int i=2,imax = n >> 2, i1, i2, i3, i4; i <= imax; ++i) {
      /** @TODO this can be optimized */
      i4 = 1 + (i3 = np3 - (i2 = 1 + (i1 = i + i - 1)));
      --i4; 
      --i2; 
      --i3; 
      --i1; 
      h1i =  c1*(data[i2] - data[i4]);
      h2r = -c2*(data[i2] + data[i4]);
      h1r =  c1*(data[i1] + data[i3]);
      h2i =  c2*(data[i1] - data[i3]);
      data[i1] = (float) ( h1r + wr*h2r - wi*h2i);
      data[i2] = (float) ( h1i + wr*h2i + wi*h2r);
      data[i3] = (float) ( h1r - wr*h2r + wi*h2i);
      data[i4] = (float) (-h1i + wr*h2i + wi*h2r);
      wr = (wtemp=wr)*wpr - wi*wpi + wr;
      wi = wi*wpr + wtemp*wpi + wi;
    }
    if (isign) {
      float tmp = data[0]; 
      data[0] += data[1];
      data[1] = tmp - data[1];
    } 
    else {
      float tmp = data[0];
      data[0] = c1 * (tmp + data[1]);
      data[1] = c1 * (tmp - data[1]);
      four1(data, n>>1, false);
    }
  }

  /**
   * four1 algorithm.
   * 
   * @param data
   *            the data.
   * @param nn
   *            the nn.
   * @param isign
   *            regular or inverse.
   */
  private  void four1(float data[], int nn, boolean isign) {
    int n, mmax, istep;
    double wtemp, wr, wpr, wpi, wi, theta;
    float tempr, tempi;

    n = nn << 1;        
    for (int i = 1, j = 1; i < n; i += 2) {
      if (j > i) {
        // SWAP(data[j], data[i]);
        float swap = data[j-1];
        data[j-1] = data[i-1];
        data[i-1] = swap;
        // SWAP(data[j+1], data[i+1]);
        swap = data[j];
        data[j] = data[i]; 
        data[i] = swap;
      }      
      int m = n >> 1;
      while (m >= 2 && j > m) {
        j -= m;
        m >>= 1;
      }
      j += m;
    }
    mmax = 2;
    while (n > mmax) {
      istep = mmax << 1;
      theta = 6.28318530717959f / mmax;
      if (!isign)
        theta = -theta;
      wtemp = Math.sin(0.5f * theta);
      wpr = -2.0f * wtemp * wtemp;
      wpi = Math.sin(theta);
      wr = 1.0f;
      wi = 0.0f;
      for (int m = 1; m < mmax; m += 2) {
        for (int i = m; i <= n; i += istep) {
          int j = i + mmax;
          tempr = (float) (wr * data[j-1] - wi * data[j]);  
          tempi = (float) (wr * data[j]   + wi * data[j-1]);  
          data[j-1] = data[i-1] - tempr;
          data[j]   = data[i] - tempi;
          data[i-1] += tempr;
          data[i]   += tempi;
        }
        wr = (wtemp = wr) * wpr - wi * wpi + wr;
        wi = wi * wpr + wtemp * wpi + wi;
      }
      mmax = istep;
    }
  }
}

int sq_w;
int sq_h;
int row;
int col;
boolean b;

public void drawGlowingBackgroundInteractive () {
  
 b = !b;
 if (b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,mouseX,mouseY) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
 }
 
  if (!b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( mouseY ,0 , width , 0 , 255 )
            ,map ( mouseX , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,i,j) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
 }
}

public void drawColorfullBackgroundInteractive () {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,mouseX,mouseY) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
}


public void drawColorfullBackgroundStatic () {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,i,j) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
}

public void drawGlowingBackgroundStatic () {
  
 b = !b;
 if (b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,i,j) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
 }
 
  if (!b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( j ,0 , width , 0 , 255 )
            ,map ( i , 0 , height , 0 , 255 )
            ,map ( dist (width/2,j,i,height/2) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
 }
}


public void drawGrayInterferenceBackground () {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (random(200,255)
            ,random(200,255)
            ,random(200,255)
      );
      rect (i , j , 1 , 1);
   }
  }
}

public void drawGrayInterferenceBackgroundFast () {
  for ( int i = 0 ; i < width ; i +=6 ) {
    for ( int j = 0 ; j < height; j+=6 ) {
      noStroke();
      fill  (random(200,255)
            ,random(200,255)
            ,random(200,255)
      );
      rect (i , j , 6 , 6);
   }
  }
}


public void drawColorfullBackgroundStaticFast () {
  for ( int i = 0 ; i < width ; i +=6 ) {
    for ( int j = 0 ; j < height; j+=6 ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,i,j) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 6 , 6);
    }
  }
}

  public int sketchWidth() { return displayWidth; }
  public int sketchHeight() { return displayHeight; }
}
