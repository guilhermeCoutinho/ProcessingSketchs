import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.testbed.*;
import org.jbox2d.collision.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;

private static final int REMOVED = 0;
private static final int TO_BE_REMOVED = 1 ;
private static final int EXISTS = 2;
Physics physics;

Body platform;
CollisionDetector detector; 
Body [] blocks;
Body bolinha;

int []blocksExists;
float score = 0;
float speed = 10;
float bodySize = 40;
float marginW ;
float marginH ;
float distanceW;
float distanceH;
float sizeW;
float sizeH; 
float platformY ;
float platformW;
float platformH;
float bolinhaR ;
boolean gameStarted = false;
int lives = 3;

void setup() {
  size(240, 320);

  physics = new Physics(this, width, height,0, 0, width*2, height*2, width, height, 100);
  detector = new CollisionDetector (physics, this);
  
  marginW = width / 40;
  marginH = height / 40;
  distanceW = width / 20;
  distanceH = height / 50;
  sizeW = ( width  - marginW * 2 - distanceW * 3 )/ 4;
  sizeH = (height - marginH *2 ) / 30 ; 
  platformY = height - marginH - sizeH ;
  platformW = sizeW*1.3;
  platformH = sizeH * 0.8;  
  blocks = new Body[16];
  bolinhaR = height / 20;
  blocksExists = new int[blocks.length] ;
  
  for (int i = 0; i < blocks.length ; i++) {
    blocksExists[i] = EXISTS;
  }

  physics.setDensity (10.0);
  bolinha = physics.createCircle (width/2 , platformY - bolinhaR/4 - platformH , bolinhaR/2 );
  physics.setDensity (0);
  
  platform = physics.createRect (width/2 , platformY ,width/2+platformW ,platformY+platformH  );

  for (int j = 0 ; j < 4 ; j ++) {
    for ( int i = 0 ; i < 4 ; i++ ){
      blocks[j*4 + i] = physics.createRect ( marginW + distanceW * i + sizeW * i , marginH + distanceH * j + sizeH * j ,  marginW + distanceW * i + sizeW * i + sizeW , marginH + distanceH * j + sizeH * j + sizeH  );
    }
  }
  physics.setCustomRenderingMethod(this, "myCustomRenderer");
}

void draw () {
  platform.setPosition (physics.screenToWorld(new Vec2(mouseX, platformY)));
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
  
  if (aux.y > platformY) {
    lives --;
    gameStarted = false;
    bolinha.setPosition(physics.screenToWorld(new Vec2 (width/2 , platformY - platformH - marginH)) );
    bolinha.setLinearVelocity(new Vec2 (0,0)) ;
  }
}

void mousePressed () {
  if (!gameStarted) {
    gameStarted = true;
    Vec2 impulse = new Vec2();
    impulse.set(bolinha.getWorldCenter());
    impulse = impulse.sub(platform.getWorldCenter());
    impulse = impulse.mul(5);
    bolinha.applyImpulse(impulse, bolinha.getWorldCenter());
    println(impulse);
  }
}

void myCustomRenderer (World world) {
  background(140);
  rectMode(CENTER);
  
  for ( int i = 0 ; i < 16 ; i ++ ) {
    if (blocksExists[i] == TO_BE_REMOVED ) {
      physics.removeBody(blocks[i]);
      blocksExists[i] = REMOVED;
    }else if (blocksExists[i] == EXISTS){
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
  text ("LIVES: " + lives , marginW*20 , height - marginH);
  if (lives <= -10 ) {
    physics.destroy();
    text("you lose" , width/2 , height/2);
  }
  if (score >= 480) {
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
   
   
   for ( int i = 0 ; i < 16 ; i++ ) {
     if (blocksExists[i] == EXISTS) {
       if (b1 == blocks[i] || b2 == blocks[i] ) {
         blocksExists[i] = TO_BE_REMOVED;
         score += 30;
       }
     }
   }
}

