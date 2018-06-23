class Hook extends Entity {
  boolean hit;
  Hook(float x, float y, float velX, float velY) {
    super(x, y, 0.5*blockWidth, 0.5*blockHeight, true);
    vel.x=velX;
    vel.y=velY;
  }
  void hookUpdate() {
    if(hit) playerForces();
    if(touchingBlocks.size()>0) {
      hit=true;
      vel.x=0;
      vel.y=0;
      pos.x=touchingBlocks.get(0).x*blockWidth+blockWidth/4;
      pos.y=touchingBlocks.get(0).y*blockHeight+blockHeight/4;
    }
  }
  void playerForces() {
    
  }
  void display() {
    fill(0, 255, 0);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
}