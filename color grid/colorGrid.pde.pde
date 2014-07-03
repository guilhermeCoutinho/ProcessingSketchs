int sq_w;
int sq_h;
int row;
int col;
boolean b;


void setup () {
  size(300,400);
  col = 30;
  row = 30;
  sq_w = width/col;
  sq_h = height/row;
}

void draw () {
  
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
  
  for ( int i = 0 ; i < col ; i ++ ) {
    for ( int j=0 ; j < row ; j ++ ) {
      
      rect (i*sq_w , j*sq_h , width , height );
    }
  }

  
}

