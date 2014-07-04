PImage []stickR;
PImage []stickU;
PImage []stickL;
int rCurrFrame = 0 , uCurrFrame = 0,lCurrFrame=0;
boolean moveRight = true ;
PImage lol ;
float speed;


void setup () {
  size (480 , 640 );
  stickR = loadImages ("walk_r/walk_r " , ".png" , 15);
  stickU = loadImages ("walk_up/walk_up " , ".png" , 17);
  stickL = loadImages ("walk_l/walk_l ",".png",15);
}

void draw () {

  imageMode(CENTER);
  speed = map ( abs(mouseX-pmouseX) , 0, width , 0 , 1 );
  
  if ( mouseX < pmouseX ) {
    background (140);
    image (stickL[lCurrFrame],mouseX , mouseY);
    lCurrFrame += ceil(1*speed);
  }else if ( mouseX > pmouseX) {
    background (140);
    image(stickR[rCurrFrame],mouseX,mouseY);
    rCurrFrame += ceil(1*speed);  
}

  if (lCurrFrame == 15 ) {lCurrFrame = 0;}
  if (rCurrFrame == 15 ) {rCurrFrame = 0;}
}

