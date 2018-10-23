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
    while(player.pos.y-pos.y-height/2-6*blockWidth>0) {
      pos.y++;
    }
    while(player.pos.y-pos.y-height/2+6*blockWidth<0) {
      pos.y--;
    }
    if(pos.x<0) pos.x=0;
    if(pos.y<0) pos.y=0;
  }
}