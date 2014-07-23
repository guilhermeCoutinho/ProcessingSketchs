

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
