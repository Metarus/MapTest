class Camera {
  PVector pos;
  Camera(PVector start) {
    pos=start;
  }
  void update() {
    while(player.pos.x-pos.x-width/2-5*blockWidth>0) {
      pos.x++;
    }
    while(player.pos.x-pos.x-width/2+5*blockWidth<0) {
      pos.x--;
    }
    if(pos.x<0) pos.x=0;
  }
}