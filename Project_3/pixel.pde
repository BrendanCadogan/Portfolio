class pixel{
  int x ,y, size;
  color col;
  
  public pixel(int x, int y, int size){
    col = (255);
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void changeColor(color Col){
    col = Col;
  }
  void display(){
    fill(col);
    rect(x, y, size, size); 
  }
  
}
