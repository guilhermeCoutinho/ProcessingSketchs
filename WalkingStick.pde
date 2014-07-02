private static final int WALK_LEFT = 1 ;
private static final int WALK_RIGHT = 2 ;
private static final int STAY = 3 ;
private static int walkingState; 
StickFigure stick ;
int armAngle;
int legAngle;
boolean flag ;

void setup () {
  size ( 1000 , 720);
  strokeWeight(6);
  fill(220);
  stick = new StickFigure();
  initializeStick () ;
}

void initializeStick () {
stick.head = new Head (mouseX,mouseY) ;
stick.nose = new Nose (mouseX , mouseY , WALK_RIGHT);
stick.lArm = new Arm (mouseX,mouseY, armAngle );
stick.rArm = new Arm (mouseX,mouseY,180-armAngle );
stick.body = new Body (mouseX,mouseY )  ;
stick.lLeg = new Leg (mouseX,mouseY,legAngle) ;
stick.rLeg = new Leg (mouseX,mouseY,180-legAngle);
}

void updateStick () {
stick.head.updatePosition(mouseX , mouseY);
stick.body.updatePosition(mouseX , mouseY);
stick.lArm.updatePosition (mouseX , mouseY , armAngle);
stick.rArm.updatePosition(mouseX , mouseY , 180-armAngle );
stick.lLeg.updatePosition (mouseX , mouseY , legAngle );
stick.rLeg.updatePosition (mouseX , mouseY , 180-legAngle );
stick.nose.updatePosition ( mouseX , mouseY,walkingState);
}


void draw () {
background(220);
updateStick();
stick.drawStick();

if ( pmouseX - mouseX > 0.5 ) {
  walkingState = WALK_LEFT;
}
else if ( pmouseX - mouseX > -0.5 ) {
  walkingState = STAY;
}
else {
  walkingState = WALK_RIGHT;
}

if ( abs(pmouseX - mouseX) > 0.5 ) {
  if ( flag ){
    armAngle = armAngle + ceil(abs(pmouseX - mouseX));
    legAngle = legAngle + ceil(abs(pmouseX - mouseX));
  }else {
    armAngle = armAngle - ceil(abs(pmouseX - mouseX));
    legAngle = legAngle - ceil(abs(pmouseX - mouseX));
  }

  if ( armAngle > 90 ) {
    flag = false;
  }
  if ( armAngle < 0 ) {
    flag = true;
  }
  
  println (armAngle);
}
else{
  armAngle = round(map( armAngle , 0 , 100 , 10, 90 ));
  legAngle = round(map( legAngle , 0 , 100 , 35 , 90));
}

}


void mousePressed () {

}
