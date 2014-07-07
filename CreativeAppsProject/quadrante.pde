static final int TOP_Q = 1;
static final int LEFT_Q = 2;
static final int BOT_Q = 3;
static final int RIGHT_Q = 4;

int quadrante (){ 
  float ry = -(height/width) * mouseX ;
  float sy = (height/width) * mouseX - height;
  if (-mouseY < ry ) {
    if (-mouseY < sy){
//      println ("MOVE_BOT");  
      return BOT_Q;
  }
    else {
//      println ("MOVE_LEFT");
      return LEFT_Q;
    }
  }
  else {
    if (-mouseY < sy){
//      println ("MOVE_RIGHT");
      return RIGHT_Q;
    }
    else {
//      println ("MOVE_TOP");
      return TOP_Q;
    }
  }
}
