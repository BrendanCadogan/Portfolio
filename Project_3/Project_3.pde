ArrayList<button> buttons;
ArrayList<pixel> Pixels;
int w, h, weight, tool, lastTool, undo_redo_frame, toolTemp, xPixels, yPixels, mode; //drawing area width and height, strokeweight
float scale, xPan, yPan;
boolean changeColorTemp, weightChangeTemp, pressedInBounds, delayDraw, drawPixelArtTemp; //delayDraw is used to turn off draw, fill, and erase for one mouseclick to solve a bug with colorwheel
color backCol = color(255,255,255);
color col = color(0,0,0); //current color
PImage mouse, mouse2, bucket, bucket2, eraser, eraser2, undo, undo2, redo, redo2, colorPicker, colorPicker2, colorWheel, colorWheel2, Weight, Weight2, Pixel, Pixel2, save, save2, xbutton, xbutton2;
UndoRedo undoredo;
boolean controlDown = false;
boolean shiftDown = false;
FloodFill1 myFloodFill;
PImage colChange, weightChange;
ColorChanger cc;

void setup(){
  frameRate(1000);
  background(255); 
  size(900,900);
  buttons = new ArrayList<button>();
  Pixels = new ArrayList<pixel>();
  undoredo = new UndoRedo(100);
  for(int i = 0; i < 18; i++){
    buttons.add(new button(50, 50, 50*i, 0)); 
  }
  fill(backCol);
  w = 800;
  h = 800;
  weight = 5;
  tool = 0;
  scale = 1;
  xPan = width/2;
  yPan = height/2;
  xPixels = 32;
  yPixels = 32;
  mode = 0;
  mouse = loadImage("mouse.png");
  mouse2 = loadImage("mouse2.png");
  eraser = loadImage("eraser.png");
  eraser2 = loadImage("eraser2.png");  
  bucket = loadImage("bucket.png");
  bucket2 = loadImage("bucket2.png");
  undo = loadImage("undo.png");
  undo2 = loadImage("undo2.png");
  redo = loadImage("redo.png");  
  redo2 = loadImage("redo2.png"); 
  colorPicker = loadImage("colorPicker.png");
  colorPicker2 = loadImage("colorPicker2.png");
  colorWheel = loadImage("colorWheel.png");
  Weight = loadImage("weight.png");
  Weight2 = loadImage("weight2.png");
  Pixel = loadImage("pixel.png");
  Pixel2 = loadImage("pixel2.png");
  save = loadImage("save.png");
  save2 = loadImage("save2.png");
  colorWheel2 = loadImage("colorWheel2.png");
  xbutton = loadImage("xbutton_20x20.png");  
  xbutton2 = loadImage("xbutton2_20x20.png");
  rect(50,50,w,h); //the drawing area
  changeColorTemp = true;
  weightChangeTemp = true;
  drawPixelArtTemp = true;
  delayDraw = false;
}

void draw(){
  translate(width/2, height/2);
  scale(scale);
  translate(-xPan, -yPan);

  for(int i = 0; i < 18; i++){
    buttons.get(i).display(); 
  }
  fill(255);
  stroke(0);
  rect(0, 50, 50, 860); //these three rect functions are used so the user can't draw outside of the drawing area
  rect(w+50,50,900-w,900);
  rect(50, h+50, 860,100);
  strokeWeight(1);
  line(w+50, h+50, w+50, 900);
  line(0, 0, 900, 0);
  coordinates();
  image(mouse, 0, 0);
  loadPixels();
  myFloodFill = new FloodFill1();
  myFloodFill.DoFill(25, 25, col);
  updatePixels();
  image(bucket, 50, 0);
  loadPixels();
  myFloodFill = new FloodFill1();
  myFloodFill.DoFill(89, 27, col);
  updatePixels();
  image(eraser, 100, 0);
  image(undo, 150, 0);
  image(redo, 200, 0);  
  image(colorPicker, 250, 0);
  loadPixels();
  myFloodFill = new FloodFill1();
  myFloodFill.DoFill(254, 45, col);
  myFloodFill.DoFill(259, 39, col); 
  updatePixels();
  image(colorWheel, 350, 0);
  image(Weight, 400, 0);
  image(Pixel, 800, 0);
  image(save, 850, 0);
  if(mouseY > 0 && mouseY < 50){
    if(mouseX > 0 && mouseX < 50){
      image(mouse2, 0, 0);
      loadPixels();
      myFloodFill = new FloodFill1();
      myFloodFill.DoFill(25, 25, col);
      updatePixels();
    }
    if(mouseX > 50 && mouseX < 100){
      image(bucket2, 50, 0);
      loadPixels();
      myFloodFill = new FloodFill1();
      myFloodFill.DoFill(89, 27, col);
      updatePixels();
    }
    if(mouseX > 100 && mouseX < 150){
      image(eraser2, 100, 0);
    }
    if(mouseX > 150 && mouseX < 200){
      image(undo2, 150, 0);
    }
    if(mouseX > 200 && mouseX < 250){
      image(redo2, 200, 0);
    }
    if(mouseX > 250 && mouseX < 300){
      image(colorPicker2, 250, 0);
      loadPixels();
      myFloodFill = new FloodFill1();
      myFloodFill.DoFill(254, 45, col);
      myFloodFill.DoFill(259, 39, col);
      updatePixels();
    }
    if(mouseX > 350 && mouseX < 400){
      image(colorWheel2, 350, 0);
    }
    if(mouseX > 400 && mouseX < 450){
      image(Weight2, 400, 0);
    }
    if(mouseX > 800 && mouseX < 850){
      image(Pixel2, 800, 0);
    }
    if(mouseX > 850 && mouseX < 900){
      image(save2, 850, 0);
    }
  }
  if(mode != 1){
    if(tool == 0){
      if(delayDraw){
        delayDraw = false;
        mousePressed = false;
      }
      image(mouse2, 0, 0);
      Draw(); 
      loadPixels();
      myFloodFill = new FloodFill1();
      myFloodFill.DoFill(25, 25, col);
      updatePixels();
    }
    else if(tool == 1){
      if(delayDraw){
        delayDraw = false;
        mousePressed = false;
      }
      Fill();
      image(bucket2, 50, 0);
      loadPixels();
      myFloodFill = new FloodFill1();
      myFloodFill.DoFill(89, 27, col);
      updatePixels();
    }
    else if(tool == 2){
      if(delayDraw){
        delayDraw = false;
        mousePressed = false;
      }
      erase(); 
      image(eraser2, 100, 0);
    }
    else if(tool == 3){
      undoredo.undo();
      tool = lastTool;
    }
    else if(tool == 4){
      undoredo.redo();
      tool = lastTool;
    }
    else if(tool == 5){
      if(delayDraw){
        delayDraw = false;
        mousePressed = false;
      }
      colorPicker(); 
      image(colorPicker2, 250, 0);
      loadPixels();
      myFloodFill = new FloodFill1();
      myFloodFill.DoFill(254, 45, col);
      myFloodFill.DoFill(259, 39, col);
      updatePixels();
    }
    else if(tool == 7){
      image(colorWheel2, 350, 0);
      changeColor();  
    }
    else if(tool == 8){
      image(Weight2, 400, 0);
      changeStrokeWeight();
    }
  }
  if(tool == 16 || mode == 1){
    drawPixelArt();
  }

  
}

void coordinates(){ //displays pixel coordinates of the mouse
  String coords = mouseX+","+mouseY;
  fill(255);
  strokeWeight(1);
  rect(0,height-50,50,50);
  fill(0);
  text(coords, 0,height-20);  
}

void Draw(){ //
  if(mousePressed && (pmouseX > 50 || mouseX> 50) && (pmouseX < w+50 || mouseX < w+50) && (pmouseY > 50 || mouseY > 50) && (pmouseY < h+50 || mouseY < h+50)){
    strokeWeight(weight);
    stroke(col);
    line(pmouseX,pmouseY,mouseX,mouseY);
  }
}

void Fill(){
  if(mousePressed && mouseX > 50 && mouseX < w+50 && mouseY < h+50 && mouseY > 50){
    loadPixels();
    myFloodFill = new FloodFill1();
    if (mousePressed) {
      myFloodFill.DoFill(mouseX, mouseY, col);
      updatePixels();
    }
  }
}

 
void erase(){ //eraser function
  if(mousePressed && (pmouseX > 50 || mouseX> 50) && (pmouseX < w+50 || mouseX < w+50) && (pmouseY > 50 || mouseY > 50) && (pmouseY < h+50 || mouseY < h+50)){
    strokeWeight(weight);
    stroke(backCol);
    line(pmouseX,pmouseY,mouseX,mouseY);
  } //<>//
}

void colorPicker(){
  if(mousePressed && (mouseX > 50 && mouseX < 750 && mouseY > 50 && mouseY < 750)){
    col = get(mouseX, mouseY);
  }
}

void changeColor(){
   if(changeColorTemp){  //true if the color picker button was pressed and wasn't already open
     colChange = get();
     cc = new ColorChanger(500, 50, 400, 400, 255);
     changeColorTemp = false;
   }
   cc.render();
   if(mouseX > 540 && mouseX < 560 && mouseY > 460 && mouseY < 480){
     image(xbutton2, 540, 460);
   }
   else{
     image(xbutton, 540, 460);
   }
   if(mousePressed && ((mouseX > 500 && mouseX < 520 && mouseY > 460 && mouseY < 480) || ((mouseX > 0 && mouseX < 150) || (mouseX > 350 && mouseX < 400) && mouseY > 0 && mouseY < 50))){ //checks if draw, paint, eraser, color picker or the current color buttons were pressed 
     col = get(510, 470);
     image(colChange, 0, 0);
     changeColorTemp = true;
     tool = lastTool;
     delayDraw = true;
     println(lastTool);
 
   }
   else if(mousePressed && mouseX > 540 && mouseX < 560 && mouseY > 460 && mouseY < 480){ //checks if x-out button was pressed
     image(colChange, 0, 0);
     changeColorTemp = true;
     tool = lastTool;
     println(lastTool);
   }
   
}

void changeStrokeWeight(){
  if(weightChangeTemp){
     weightChange = get();
     weightChangeTemp = false;
  }
  fill(255);
  rect(450, 50, 50, 20);
  for(int i = 1; i < 21; i++){
    if(mouseX > 400 && mouseX < 450 && mouseY > 50+(i-1)*15 && mouseY < 65+(i-1)*15){
      strokeWeight(i);
      line(460, 60, 490, 60);
      fill(120);
      if(mousePressed){
        weight = i; 
        image(weightChange, 0, 0);
        tool = lastTool;
        weightChangeTemp = true;
        delayDraw = true;
        return;
      }
    }
    else{
      fill(255);
    }
    strokeWeight(1);
    rect(400, 50+(i-1)*15, 50, 15);
    fill(0);
    text(i, 410, 50+i*15);
  }
}

void drawPixelArt(){
  if(drawPixelArtTemp){
    populatePixels();
    fill(0);
    rect(50, 50, 800, 800);
    drawPixelArtTemp = false;
  }
  for(int i = 0; i < Pixels.size(); i++){
    Pixels.get(i).display(); 
    if(tool == 0){
      if(mousePressed && mouseX > Pixels.get(i).x && mouseX < Pixels.get(i).x+Pixels.get(i).size && mouseY > Pixels.get(i).y && mouseY < Pixels.get(i).y+ Pixels.get(i).size){
        println(Pixels.get(i).x);
        Pixels.get(i).changeColor(col);
      }
    }
  }
}

void populatePixels(){
  for(int i = 50; i < 850; i = 800/xPixels+i){
    for(int j = 50; j < 850; j = (800/yPixels)+j){
      Pixels.add(new pixel(i, j, 800/xPixels));
    } 
  }
}

void mouseReleased(){ //current bug is that it won't screenshot if you are drawing and release when you are hovering over a button
    for(int i = 0; i < 18; i++){
      if(buttons.get(i).gethover() && buttons.get(i).getisPressed() && i == toolTemp){ //<>//
        if(tool != 7 && tool != 8){      
          lastTool = tool;
          tool = i;
        }       
        if(tool == 16 && mode == 1){
          mode = 0; 
          tool = 0;
          background(255);
        }
        else if(tool == 16){
          mode = 1;
          tool = 0;
        }
        return;
      }  
    }
  if(tool != -1 && tool != 7 && tool != 8 && tool != 17 && (pressedInBounds || mouseX > 50 && mouseX < 850 && mouseY > 50 && mouseY < 850)){ //if tool is colorchooser or strokechanger
    println(tool);
    undoredo.takeSnapshot();
    pressedInBounds = false;
  }
  
}

void keyPressed() {
  // Remember if CTRL or SHIFT are pressed or not
  if (key == CODED) {
    if (keyCode == CONTROL) 
      controlDown = true;
    if (keyCode == SHIFT)
      shiftDown = true;
    return;
  } 
  // Check if we pressed CTRL+Z or CTRL+SHIFT+Z
  if (controlDown) {
    if (keyCode == 'Z') {
      if (shiftDown)
        undoredo.redo();
      else
        undoredo.undo();
    }
    return;
  } 
  // Check if we pressed the S key
  if (key=='s') {
    saveFrame("image####.png");
  }
}
void keyReleased() {
  // Remember if CTRL or SHIFT are pressed or not
  if (key == CODED) {
    if (keyCode == CONTROL) 
      controlDown = false;
    if (keyCode == SHIFT)
      shiftDown = false;
  }
}

void mousePressed(){
  if(mouseX > 850 && mouseX < 900 && mouseY > 0 && mouseY < 50){
    saveFrame(); 
    print("saved");
  } 
  if(mouseX > 50 && mouseX < 850 && mouseY > 50 && mouseY < 850){ //makes sure doesn't screenshot when it shouldn't
    pressedInBounds = true; 
  }
  
  for(int i = 0; i < 18; i++){ //used to fix bug with screnshoting and buttons
    if(buttons.get(i).gethover()){
       toolTemp = i;
       return;
    }
  }
}
