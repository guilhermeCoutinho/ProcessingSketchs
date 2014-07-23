int sq_w;
int sq_h;
int row;
int col;
boolean b;

public void drawGlowingBackgroundInteractive () {
  
 b = !b;
 if (b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
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
}

public void drawColorfullBackgroundInteractive () {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,mouseX,mouseY) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
}


public void drawColorfullBackgroundStatic () {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,i,j) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
}

public void drawGlowingBackgroundStatic () {
  
 b = !b;
 if (b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,i,j) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
 }
 
  if (!b) {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (map ( j ,0 , width , 0 , 255 )
            ,map ( i , 0 , height , 0 , 255 )
            ,map ( dist (width/2,j,i,height/2) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 1 , 1);
    }
  }
 }
}


public void drawGrayInterferenceBackground () {
  for ( int i = 0 ; i < width ; i ++ ) {
    for ( int j = 0 ; j < height; j++ ) {
      noStroke();
      fill  (random(200,255)
            ,random(200,255)
            ,random(200,255)
      );
      rect (i , j , 1 , 1);
   }
  }
}

public void drawGrayInterferenceBackgroundFast () {
  for ( int i = 0 ; i < width ; i +=6 ) {
    for ( int j = 0 ; j < height; j+=6 ) {
      noStroke();
      fill  (random(200,255)
            ,random(200,255)
            ,random(200,255)
      );
      rect (i , j , 6 , 6);
   }
  }
}


public void drawColorfullBackgroundStaticFast () {
  for ( int i = 0 ; i < width ; i +=6 ) {
    for ( int j = 0 ; j < height; j+=6 ) {
      noStroke();
      fill  (map ( i , 0 , width , 0 , 255 )
            ,map ( j , 0 , height , 0 , 255 )
            ,map ( dist (width/2,height/2,i,j) , 0 , dist (0,0,width/2,height/2) , 0 ,255 )
      );
      rect (i , j , 6 , 6);
    }
  }
}
