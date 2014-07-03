private static final int SHOW_SPLASH_SCREEN = 1;
private static final int LOAD_AUDIO = 2;
private static final int READY_TO_GO = 3;
private int appStage;
Maxim maxim;
AudioPlayer player;
PImage img ;

void setup () {
  size(1000,500);
  appStage = SHOW_SPLASH_SCREEN;
  img = loadImage ("image.jpg") ;
}

void draw () {
  switch (appStage) {
  case LOAD_AUDIO : 
    maxim = new Maxim(this);                  
    player = maxim.loadFile("mybeat.wav");
    player.play();
    appStage = READY_TO_GO;
  
 break;
 case SHOW_SPLASH_SCREEN : 
      image (img , 0 , 0); 
      appStage = LOAD_AUDIO;
      println("image should go on screen now");
  break;
  case READY_TO_GO : // INITIALIZING IS DONE
  }
}
