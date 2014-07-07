static final int MOVE_DOWN = 1;
static final int MOVE_RIGHT = 2;
static final int MOVE_LEFT = 3;
static final int MOVE_UP = 4;

PImage []stickR;
PImage []stickU;
PImage []stickL;
int rCurrFrame = 0 , uCurrFrame = 0,lCurrFrame=0;
boolean b;
int animationStage;
int x;
int y;
boolean play_piano , play_guitar , play_drums , play_sax ;


Maxim maxim;
AudioPlayer guitar , piano , sax , drums;


void setup () {
  size (300 , 400 );
  imageMode (CENTER); 
  stickR = loadImages ("walk_r/walk_r " , ".png" , 15);
  stickU = loadImages ("walk_up/walk_up " , ".png" , 17);
  stickL = loadImages ("walk_l/walk_l ",".png",15);
  maxim = new Maxim (this);
  guitar = maxim.loadFile ("audio/guitar.wav");
  piano = maxim.loadFile ("audio/piano.wav");
  sax = maxim.loadFile ("audio/sax.wav");
  drums = maxim.loadFile ("audio/drums.wav");
  y = 0;
  x = 50;
  animationStage = MOVE_DOWN;
 
  println ("guitar:" , guitar.getLengthMs() );
  println ("drums:" , drums.getLengthMs() );
  println ("sax:" , sax.getLengthMs() );
  println ("piano:" , piano.getLengthMs () ) ;
  
}

void reset () {
  piano.cue(0);
  drums.cue(0);
  guitar.cue(0);
  sax.cue(0);
}


void draw () {  
  guitar.speed (  guitar.getLengthMs() / drums.getLengthMs ()/ 2 ) ;
  piano.speed ( piano.getLengthMs() / drums.getLengthMs () / 4 );
  sax.speed ( sax.getLengthMs() / drums.getLengthMs () / 8 ) ;
  if ( play_piano ) {piano.play();}else {piano.stop();}
  if (play_guitar ) {guitar.play();}else {guitar.stop();}
  if ( play_drums ) {drums.play();}else {drums.stop();}
  if ( play_sax ) {sax.play();}else {sax.stop();}
  
    b = !b;
 if (b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( mouseX , 0 , width , 0 , 255 )
            ,map ( mouseY , 0 , height , 0 , 255 )
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
  stroke (255);
  noFill();

  line (0,0,width,height);
  line (0,height,width,0);
 
  drawStick();
}

void mousePressed () {
     switch (quadrante () ) {
      case TOP_Q: play_drums = !play_drums;reset();
      break;
      case LEFT_Q: play_piano = !play_piano;reset();
      break;
      case RIGHT_Q: play_guitar = !play_guitar;reset();
      break;
      case BOT_Q: play_sax = !play_sax;reset();
      break;
    }
}

void drawStick () {
  
  
  switch (animationStage) {
    case MOVE_DOWN:  image (stickU[uCurrFrame] , 50 , y , 100 ,140);
                     y += 6;
                     uCurrFrame ++;
                     if ( y >=height-50) {animationStage = MOVE_RIGHT;}
    break;
    case MOVE_RIGHT: image (stickR[rCurrFrame] , x , y , 100 , 140);
                     x+= 4;
                     rCurrFrame ++;
                     if (x >= width-50) {animationStage = MOVE_UP;}
    break;
    case MOVE_UP: image (stickU[uCurrFrame] , x , y , 100 , 140);
                  y-=6;
                  uCurrFrame ++;
                  if ( y <= 50) {animationStage = MOVE_LEFT;}
    break;
    case MOVE_LEFT:image (stickL[lCurrFrame] , x , y , 100, 140);
                   x-=4;
                   lCurrFrame++;
                   if (x <= 50 ) {animationStage = MOVE_DOWN;}
    break;
  }
  
  if (uCurrFrame >= 17 ) {uCurrFrame = 0;}
  if (rCurrFrame >= 15 ) {rCurrFrame = 0;}
  if (lCurrFrame >= 15 ) {lCurrFrame = 0;}
  
}

