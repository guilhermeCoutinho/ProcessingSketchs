private final static int BLANK = 0;
private final static int BLACK = 1;
private final static int ORANGE = 2;
private final static int BLUE = 3;


public class Grid {
  private Piece[][] board = new Piece[ROWS][COLS];
  private Piece currPlayer ;
  private boolean orangeWins;
  private boolean blackWins;
  private int countB = 0 , countO = 0;
  private int [] I = new int[4];
  private int [] J = new int[4];

  public Grid (int cor) {
    reset();
    currPlayer = new Piece (cor);
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
    checkWinDiag();
    if ( orangeWins ){winner = ORANGE;}
    if ( blackWins ) {winner = BLACK;}
    return -1;
}

  private void paintWinner () {
    for (int i = 0 ; i < 4 ; i++) {
      board[I[i]][J[i]].setCor(BLUE);
    }
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

  private void checkSecondaryDiagonal (int i , int j) {
    for ( ; i>= 0 && j < COLS ; i--,j++) if (findWin(i,j) ) break;
  }
  
  private void checkPrincipalDiagonal ( int i , int j ) {
    for ( ; i < ROWS && j < COLS ; i++ , j++) if (findWin(i,j) ) break;
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
    if (board[i][j].getCor() == BLANK ) {
      countB = 0;
      countO = 0;
      }
    else if (board[i][j].getCor() == BLACK ) {
      I[countB] = i;
      J[countB] = j;
      countB ++;
      countO = 0;
      if (countB == 4 ) {
        blackWins = true;
        paintWinner();
        } 
      }
    else if (board[i][j].getCor() == ORANGE ) {
      I[countO] = i;
      J[countO] = j;
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
