import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.testbed.*;
import org.jbox2d.collision.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;


private static Physics physics;
private CollisionDetector detector;
private Body platform;
private Body [] blocks;
private Body bolinha;

public static final int REMOVED = 0;
public static final int TO_BE_REMOVED = REMOVED + 1  ;
public static final int EXISTS = TO_BE_REMOVED + 1;  

public static final int LEVEL_1 = 0;

public static final int MENU = 0;
public static final int OPTIONS = MENU + 1;
public static final int LEVEL_SELECTOR = OPTIONS + 1;
public static final int GAME_STARTED = LEVEL_SELECTOR + 1;
public static final int GAME_FINISHED = GAME_STARTED+1 ;

private int currentLevel;
private int gameStage;
private boolean gameStarted;
private float score;
private float speed;
private float marginW;
private float marginH;
private float distanceW;
private float distanceH;
private float sizeW;
private float sizeH; 
private float platformY;
private float platformW;
private float platformH;
private float bolinhaR ;
private int lives ;
private int []blocksExists;




void setup() {

  size(displayWidth , displayHeight);
  size(240, 320);
  gameStage = MENU;
}

void createLevel() {
  physics = new Physics(this, width, height,0, 0, width*2, height*2, width, height, 100);
  detector = new CollisionDetector (physics, this);

  setVariablesLevel_1();
  blocks = new Body[blocksExists.length];
  physics.setDensity (0);
  
  for (int j = 0 ; j < 6 ; j ++) {
    for ( int i = 0 ; i < 5 ; i++ ){
      blocks[j*5 + i] = physics.createRect (  marginW   + distanceW * i + sizeW * i , marginH +
                                              distanceH * j + sizeH * j ,  marginW +
                                              distanceW * i + sizeW * i + sizeW , marginH +
                                              distanceH * j + sizeH * j + sizeH  );
    }
  }
  platform = physics.createRect (width/2 , platformY ,width/2+  platformW ,platformY + platformH  );
  physics.setDensity (10.0);
  bolinha = physics.createCircle (width/2 , platformY - bolinhaR/4 - platformH , bolinhaR/2 );
  physics.setCustomRenderingMethod(this, "customRendererLevel_1");
}

 public void setVariablesLevel_1() {
    speed = 8;
    score = 0 ;
    lives = 3;
    gameStarted = false;
//    marginW = width / 40;
    marginW = width / 5;
    marginH = height / 40;
    distanceW = width / 20;
    distanceH = height / 50;
    sizeW = ( width  - marginW * 2 - distanceW * 3 )/ 5;
    sizeH = (height - marginH *2 ) / 30 ; 
    platformY = height - marginH - sizeH ;
//    platformW = sizeW * (float) 1.3;
    platformW = sizeW * (float) 3.3;
    platformH = sizeH * (float) 0.8;
    bolinhaR = height / 20;
    blocksExists = new int[30];
    for (int i = 0 ; i < blocksExists.length ; i++) {
      blocksExists[i] = EXISTS;
    }
  }

void draw () {

  switch(gameStage){
  case MENU:
    drawMenu();
  break;
  case OPTIONS:
    drawOptions ();
  break;
  case LEVEL_SELECTOR:
    drawLevelSelector();
    gameStage = GAME_STARTED;
  break;
  case GAME_STARTED:
    for (int i = 0 ; i < blocksExists.length ; i ++ ){
      if (blocksExists[i] == TO_BE_REMOVED) {
        physics.removeBody(blocks[i]);
        blocksExists[i] = REMOVED;
      }
    }
    switch (currentLevel){
      case LEVEL_1 :
        platform.setPosition(physics.screenToWorld(new Vec2(mouseX, platformY )) );
        float x = bolinha.getLinearVelocity().x;
        float y = bolinha.getLinearVelocity().y;

        if ( sqrt(x*x + y*y) < speed ) {
          bolinha.setLinearVelocity(new Vec2 (x*1.1,y*1.1)) ;
        }
        if ( sqrt(x*x + y*y) > speed ) {
          bolinha.setLinearVelocity(new Vec2 (x*0.9,y*0.9)) ;
        }

        Vec2 aux = new Vec2();
        aux = physics.worldToScreen (bolinha.getWorldCenter());

        if (aux.y > platformY - marginH ){
          lives --;
          gameStarted = false;
          bolinha.setPosition(physics.screenToWorld(new Vec2 (width/2 , platformY - platformH - marginH)) );
          bolinha.setLinearVelocity(new Vec2 (0,0)) ;
        }
      break;
    }
  break;
  case GAME_FINISHED:
  break;
  }

}

void mousePressed () {

  if (!gameStarted) {    
    gameStarted = (true);
    Vec2 impulse = new Vec2();
    impulse.set(bolinha.getWorldCenter());
    impulse = impulse.sub(platform.getWorldCenter());
    impulse = impulse.mul(5);
    bolinha.applyImpulse(impulse, bolinha.getWorldCenter());
    println(impulse);
  }

}


void drawMenu() {
  line (width/2 , 0 , width/2 , height );
  line (0 , height/2 , width , height/2);
}

void drawOptions () {

}
void drawLevelSelector() {
  createLevel();
}

void customRendererLevel_1 (World world) {
  
  background(140);
  rectMode(CENTER);
  for ( int i = 0 ; i < blocksExists.length ; i ++ ) {
    if (blocksExists[i] == EXISTS){
      Vec2 aux = physics.worldToScreen(blocks[i].getWorldCenter());
      rect(aux.x , aux.y , sizeW , sizeH );
    }
  }

  Vec2 aux = new Vec2();
  aux = physics.worldToScreen (platform.getWorldCenter());
  rect (aux.x , aux.y , platformW , platformH);

  aux = physics.worldToScreen ( bolinha.getWorldCenter());
  ellipse(aux.x,aux.y,bolinhaR , bolinhaR);

  text ("SCORE:  " + score, marginW , height - marginH );
  text ("LIVES: " + lives , marginW + 100  , height - marginH);
  if (lives <= -10 ) {
    physics.destroy();
    text("you lose" , width/2 , height/2);
  }
  if (score >= blocksExists.length * 30) {
    physics.destroy();
    text("you win" , width/2 , height/2);
  }
}

void collision(Body b1, Body b2, float impulse){
  if (b1 == platform || b2 == platform ) {
    Vec2 aux = new Vec2();
    aux.set(bolinha.getWorldCenter());
    aux = aux.sub(platform.getWorldCenter());
    aux = aux.mul(5);
    bolinha.applyImpulse(aux, bolinha.getWorldCenter());
  }

  for ( int i = 0 ; i < blocksExists.length ; i++ ) {
    if (blocksExists[i] == EXISTS) {
      if (b1 == blocks[i] || b2 == blocks[i] ) {
         blocksExists[i] = TO_BE_REMOVED;
         score += (30);
      }
    }
  }
}
