private final static int BLANK = 0;
private final static int BLACK = 1;
private final static int ORANGE = 2;


public class Grid {
  private Piece[][] board = new Piece[ROWS][COLS];
  private Piece currPlayer ;
  private boolean orangeWins;
  private boolean blackWins;
  private int countB = 0 , countO = 0;  
  

  public Grid (int cor) {
    reset();
    currPlayer = new Piece (ORANGE);
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
  }

  public int checkWin() {
    checkWinVer();
    checkWinHor();
    if ( orangeWins ) {println("orange wins");return ORANGE;}
    if ( blackWins ) {println("black wins");return BLACK;}
    return -1;
}

  private void checkWinVer () {
    for ( int i = 0 ; i < COLS ; i++ ) 
      for (int j = 0; j < ROWS; j++) 
        if( findWin(j,i) ) break;
  }
  
  private void checkWinHor () {
    for ( int i = 0 ; i < ROWS ;i ++ ) 
      for ( int j = 0 ; j < COLS ; j ++) 
         if (findWin(i,j) ) break;
  }

  private void checkWinDiag () {
    
  }

  private boolean findWin (int i, int j) {
    if (board[i][j].getCor() == BLANK ) {countB = 0 ; countO = 0;}
    else if (board[i][j].getCor() == BLACK ) {countB ++ ; countO = 0; if (countB == 4 ) { blackWins = true;} }
    else if (board[i][j].getCor() == ORANGE ) {countO ++ ; countB = 0; if (countO == 4 ) {orangeWins = true;} }
    return blackWins || orangeWins;
  }

  private void togglePlayer () {
    if (currPlayer.getCor() == BLACK ) {currPlayer.setCor(ORANGE);}
    else if (currPlayer.getCor() == ORANGE) {currPlayer.setCor(BLACK);}
  }

  public void makeMove (int col) {
    boolean mkMove = false;
    togglePlayer();
    for (int i = ROWS-1 ; i >= 0 ; i -- ) {
      if ( board[i][col].getCor() == BLANK ) {
        mkMove = true;
        board[i][col].setCor ( currPlayer.getCor() );
        break;
      }
    }
    if (!mkMove) {togglePlayer(); println ("full column");}
  checkWin();
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
