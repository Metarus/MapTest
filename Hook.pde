class Hook extends Entity {
  boolean hit;
  int index;
  ArrayList <HookSegment> segments=new ArrayList<HookSegment>();
  Hook(float x, float y, float velX, float velY, int _index) {
    super(x, y, 0.1*blockWidth, 0.1*blockHeight, 1, true);
    vel.x=velX;
    vel.y=velY;
    index=_index;
  }
  void hookUpdate() {
    if(hit) playerForces();
    if(touchingBlocks.size()>0&&!hit) {
      PVector movement=new PVector(player.pos.x-pos.x, player.pos.y-pos.y);
      movement.normalize();
      for(int i=0; i<dist(pos.x, pos.y, player.pos.x, player.pos.y); i+=90000) {
        segments.add(new HookSegment(pos.x+movement.x*i, pos.y+movement.y*i, index, i/10));
      }
      hit=true;
      vel.x=0;
      vel.y=0;
    }
  }
  void playerForces() {
    if(w) {
      segments.remove(segments.size()-1);
    }
    if(s) {
      segments.add(new HookSegment(player.pos.x, player.pos.y, index, segments.size()));
    }
    for(int i=segments.size()-1; i>=0; i--) {
      segments.get(i).seg();
    }
    for(int j=0; j<5; j++) {
      for(int i=segments.size()-1; i>=0; i--) {
        segments.get(i).segUpdate1();
        segments.get(i).checkCollisions();
      }
    }
    for(int i=0; i<segments.size(); i++) {
      segments.get(i).segUpdate2();
      segments.get(i).checkCollisions();
    }
    for(int i=0; i<segments.size(); i++) {
      segments.get(i).movement();
      segments.get(i).display();
    }
  }
  void display() {
    fill(0, 255, 0);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
}