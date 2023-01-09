class UndoRedo {
 int undoIndex = 0, redoIndex = 0;
 CircImgCollection images;
  
  UndoRedo(int levels) {
    images = new CircImgCollection(levels);
  }

  public void takeSnapshot() {
    undoIndex = min(undoIndex+1, images.amount-1);
    // each time we draw we disable redo
    redoIndex = 0;
    images.next();
    images.capture();
  }
  public void undo() {
    if(undoIndex > 0) {
      undoIndex--;
      redoIndex++;
      images.prev();
      images.show();
    }
  }
  public void redo() {
    if(redoIndex > 0) {
      undoIndex++;
      redoIndex--;
      images.next();
      images.show();
    }
  }
}


class CircImgCollection {
  int amount, current;
  PImage[] img;
  CircImgCollection(int amountOfImages) {
    amount = amountOfImages;

    // Initialize all images as copies of the current display
    img = new PImage[amount];
    for (int i=0; i<amount; i++) {
      img[i] = createImage(width, height, RGB);
      img[i] = get();
    }
  }
  void next() {
    current = (current + 1) % amount;
  }
  void prev() {
    current = (current - 1 + amount) % amount;
  }
  void capture() {
    img[current] = get();
  }
  void show() {
    image(img[current], 0, 0);
  }
}
  
  
