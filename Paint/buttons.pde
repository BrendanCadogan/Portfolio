class button{
  boolean isPressed, hover;
  int w,h,x,y;
  PImage img;
  
  public button(int wid, int hei, int X, int Y){
    isPressed = false;
    w = wid;
    h = hei;
    x = X;
    y = Y;
  }
  
  boolean getisPressed(){return isPressed;}
  
  boolean gethover(){return hover;}
  
  void update(){
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
     hover = true; 
     if(mousePressed){
       isPressed = true;
     }
    }
    else{
      hover = false;
      isPressed =false;
    }
  }
  
  void display(){
    rectMode(CORNER);
    strokeWeight(1);
    fill(255);
    stroke(0);
    rect(x,y,w,h);
    update();
  }
  
}
