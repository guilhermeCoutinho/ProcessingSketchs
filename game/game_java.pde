static final int MOVE_TOP = 1;
static final int MOVE_LEFT = 2;
static final int MOVE_BOT = 3;
static final int MOVE_RIGHT = 4;

static final int LEVEL_1_WIN = 1;
static final int LEVEL_1_FAIL = 2;
static final int LEVEL_2_WIN = 3;
static final int LEVEL_2_FAIL = 4;
static final int LEVEL_2_MIX_SQUARES = 5;
static final int LEVEL_3_WIN = 6;
static final int LEVEL_3_FAIL = 7;


Maxim maxim;
AudioPlayer player;

int level , lives ;
float width_sq;
float height_sq;

Point red = null , blue = null  , green = null , green2 = null , pink1 = null , pink2 = null;
Map map_1 , map_2 , map_3 , currMap;

void setup (){
  size (240 , 320);
  maxim = new Maxim(this);
  player = maxim.loadFile("sound.wav");
  player.play();
  level_1();
  noLoop();
}



void level_1(){
  width_sq = width/6;
  height_sq = height/8;
  map_1 = new Map();
  currMap = map_1;
  map_1.grid = new int[][] {
    {1,1,1,1,1,1},
    {1,0,0,0,0,1},
    {1,0,1,0,1,1},
    {1,0,1,0,1,1},
    {1,0,0,0,1,1},
    {1,0,1,0,1,1},
    {1,1,1,0,1,1},
    {1,1,1,1,1,1}
  };
  
  createMap ();
  red = new Point(4,1);
  blue = new Point (3,6);
  green = new Point (3,5);
  map_1.movingSq.add (red);
  map_1.pursueSquares.add( new PursueSquares (red,green) );
  map_1.events = new int[]{LEVEL_1_WIN , LEVEL_1_FAIL};
}

void level_2() {
  width_sq = width/10;
  height_sq = height/10;
  map_2 = new Map();
  currMap = map_2;
  map_2.grid = new int[][] {
    {1,1,1,1,1,1,1,1,1,1},
    {1,0,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,0,1,1,0,1,1,1,1},
    {1,1,0,1,1,0,1,1,1,1},
    {1,1,0,1,0,0,0,1,1,1},
    {1,1,0,1,1,0,1,1,1,1},
    {1,1,0,1,1,0,1,1,1,1},
    {1,1,0,0,0,0,1,1,1,1},
    {1,1,1,1,1,1,1,1,1,1}
  };
  createMap( );
  red = new Point(1,1);
  green2 = new Point (6,5);
  green = new Point (8,2);
  blue = null;
  map_2.pursueSquares.add( new PursueSquares ( red , green ) );
  map_2.pursueSquares.add( new PursueSquares ( red , green2 ) );
  map_2.movingSq.add(red);
  map_2.events = new int[] {LEVEL_2_WIN , LEVEL_2_FAIL,LEVEL_2_MIX_SQUARES};
}

void level_3 () {
  width_sq = width / 8;
  height_sq = height / 12;
  map_3 = new Map ();
  currMap = map_3;
  map_3.grid = new int[][] {
    {1,1,1,1,1,1,1,1},
    {1,1,0,1,1,1,0,1},
    {1,0,0,1,1,1,0,1},
    {1,0,0,1,1,1,0,1},
    {1,1,0,1,0,1,0,1},
    {1,1,0,1,0,1,0,1},
    {1,1,0,0,0,1,0,1},
    {1,1,1,0,1,1,0,1},
    {1,1,1,0,1,1,0,1},
    {1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1}
  };
  createMap();
  red = new Point(1,3);
  blue = new Point (4,4);
  green = new Point (2,6);
  pink1 = new Point (3,10);
  pink2 = new Point (6,4);
  map_3.movingSq.add(red);
  map_3.movingSq.add(pink1);
  map_3.movingSq.add(pink2);
  map_3.pursueSquares.add( new PursueSquares ( red , green ) );
  map_3.pursueSquares.add( new PursueSquares ( pink1 , green ) );
  map_3.pursueSquares.add( new PursueSquares ( pink2 , green ) );
  map_3.events = new int[] {LEVEL_3_WIN , LEVEL_3_FAIL};
}


void draw(){
  drawMap();
  drawElements ();
}

void pursue () {
  int i;
  for ( i = 0 ; i < currMap.pursueSquares.size() ; i ++ ) {
    Point sqA = currMap.pursueSquares.get(i).pursued;
    Point sqB = currMap.pursueSquares.get(i).pursuer;

    if (sqA.x == sqB.x){
      if (sqA.y > sqB.y){
        sqB.y++;
        if (!legalMove(sqB)) {sqB.y--;}
      }
      else if (sqA.y < sqB.y){
        sqB.y--;
        if (!legalMove(sqB)) {sqB.y++;}
      }
    }
    else if (sqA.y == sqB.y) {
      if (sqA.x > sqB.x){
        sqB.x ++;
        if (!legalMove(sqB)) {sqB.x--;}
      }else if (sqA.x < sqB.x){
        sqB.x--;
        if (!legalMove(sqB)) {sqB.x++;}
      }
    }
  }
}

boolean legalMove(Point p) {
  boolean legal = true;
  int i;
  for (i = 0 ; i < currMap.points.size() ; i ++ ) {
    if ( compare( p , currMap.points.get(i) ) ) {
      legal = false;
      break;
    }
  }
  return legal;
}

void moveSq () {
  for ( int i = 0 ; i < currMap.movingSq.size() ; i++) {
    Point sq = currMap.movingSq.get(i);
    switch (quadrante()){
    case MOVE_TOP:   sq.y -=1;
    if ( !legalMove(sq) ){ sq.y += 1;}
    break;
    case MOVE_LEFT:  sq.x -= 1;
    if ( !legalMove(sq) ){sq.x+=1;}
    break;
    case MOVE_BOT:   sq.y += 1;
    if ( !legalMove(sq) ){sq.y-=1;}
    break;
    case MOVE_RIGHT: sq.x+=1;
    if ( !legalMove(sq) ){sq.x-=1;}
    break;
    }  
  }
}


void mousePressed() {
  moveSq ( );
  if ( currMap.pursueSquares != null ) {pursue();}
  if (currMap.events != null) {checkEvents();}
  redraw();
}


void checkEvents() {
  for ( int i = 0 ; i < currMap.events.length ; i ++ ){
    int event = currMap.events[i];

    switch ( event ) {
    case LEVEL_1_WIN : if (compare(red,blue) ) {
                          level_2(); }   
    break;
    case LEVEL_1_FAIL:if ( compare (red , green) ) {
                        level_1();}
    break;
    case LEVEL_2_WIN :{ if (blue != null) {
                          if (compare (red , blue)){ 
                            green2 = null ;level_3();
                          }
                         }
    }break;
    case LEVEL_2_FAIL: if (green!= null){
                         if (compare (red , green) || compare (red,green2) ) { 
                            level_2();
                          }
                        }
    break;
    case LEVEL_2_MIX_SQUARES:  if (green!= null){  
                                  if ( compare(green,green2) ) { 
                                    blue = new Point (green.x,green.y);
                                    green = null ; green2 = null ;    
                                    currMap.pursueSquares = null;
                                  }
                                }
    break;
    case LEVEL_3_WIN:  if (compare ( red , blue ) ) {level_1();pink1 = null;pink2=null;}
    break;
    case LEVEL_3_FAIL: if (compare ( red , green ) ) {level_3();}
    break;
    }
  }
}

void drawElements () {
  stroke (255);
  if ( red != null ){fill(255,0,0);quadrado (red);}
  if ( blue!= null ){fill(0,0,255);quadrado (blue);}
  if (green!= null ){fill (0,255,0);quadrado (green);}
  if (green2 != null ) { fill (0,255,0); quadrado (green2);}
  if (pink1 != null ) {fill (255,0,0); quadrado(pink1); }
  if (pink2 != null ) {fill (255,0,0); quadrado(pink2);}
}

void drawMap() {
  int i;
  background(0);
  
  fill(0);

  stroke(255);
  for (i = 0 ; i < currMap.points.size() ; i ++) {
    quadrado(currMap.points.get(i));
  }  


  int [][]M = currMap.grid;
  stroke(0);
  fill(255);
  for ( int y = 0; y < M.length ; y ++ ) {
    for ( int x = 0 ; x < M[0].length ; x ++) {
      if (M[y][x] == 0 ){
          quadrado ( new Point ( x , y) ) ;
      }
    }
  }
  
}

void quadrado ( Point p ) {
  rect( p.x*width_sq , p.y*height_sq , width_sq , height_sq );
}


int quadrante (){ 
  float ry = -(height/width) * mouseX ;
  float sy = (height/width) * mouseX - height;
  if (-mouseY < ry ) {
    if (-mouseY < sy){
      println ("MOVE_BOT");  
      return MOVE_BOT;
  }
    else {
      println ("MOVE_LEFT");
      return MOVE_LEFT;
    }
  }
  else {
    if (-mouseY < sy){
      println ("MOVE_RIGHT");
      return MOVE_RIGHT;
    }
    else {
      println ("MOVE_TOP");
      return MOVE_TOP;
    }
  }
}

void createMap () {
  int [][]M = currMap.grid;
  for ( int y = 0; y < M.length ; y ++ ) {
    for ( int x = 0 ; x < M[0].length ; x ++) {
      if (M[y][x] == 1 ){
         currMap.points.add( new Point ( x , y ) );
      }
    }
  }

}

boolean compare ( Point a , Point b ) {
  boolean retorno = true;
  if (a.x != b.x)
    retorno = false;

  if (a.y != b.y){
    retorno = false;
  }
  return retorno;
}

private class Map {
  ArrayList<Point> points = new ArrayList<Point>();  
  ArrayList<PursueSquares> pursueSquares = new ArrayList<PursueSquares>();
  int events[];
  ArrayList<Point> movingSq = new ArrayList<Point>();
  int [][] grid;
}

private class PursueSquares {
  Point pursued ;
  Point pursuer ;
  
  PursueSquares (Point pursued , Point pursuer) {
    this.pursued = pursued ;
    this.pursuer = pursuer;
  }
}

private class Point {
  int x;
  int y;
  Point (int x,int y) {
    this.x = x;
    this.y = y;
  }
}
