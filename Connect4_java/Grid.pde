

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
