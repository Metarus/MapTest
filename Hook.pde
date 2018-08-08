class Hook extends Entity {
  boolean hit;
  float len;
  int index;
  ArrayList <HookSegment> segments=new ArrayList<HookSegment>();
  Hook(float x, float y, float velX, float velY, int _index) {
    super(x, y, 0.1*blockWidth, 0.1*blockHeight, true);
    vel.x=velX;
    vel.y=velY;
    index=_index;
  }
  void hookUpdate() {
    if(hit) playerForces();
    if(touchingBlocks.size()>0&&!hit) {
      PVector movement=new PVector(player.pos.x-pos.x, player.pos.y-pos.y);
      movement.normalize();
      for(int i=0; i<dist(pos.x, pos.y, player.pos.x, player.pos.y); i+=10) {
        segments.add(new HookSegment(pos.x+movement.x*i, pos.y+movement.y*i, index, i/10));
      }
      hit=true;
      vel.x=0;
      vel.y=0;
      len=dist(pos.x, pos.y, player.pos.x, player.pos.y);
    }
  }
  void playerForces() {
    if(w) {
      segments.remove(segments.size()-1);
    }
    if(s) {
      segments.add(new HookSegment(player.pos.x, player.pos.y, index, segments.size()));
    }
    for(int i=0; i<segments.size(); i++) {
      segments.get(i).update();
      segments.get(i).segUpdate();
      segments.get(i).display();
    }
  }
  void display() {
    fill(0, 255, 0);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
}