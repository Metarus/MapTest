class Hook extends Entity {
  boolean hit;
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
      segments.add(new HookSegment(pos.x+dim.x/2, pos.y+dim.y/2, dist(pos.x, pos.y, player.pos.x+player.dim.x/2, player.pos.y+player.dim.y/2), index, 0));
      hit=true;
      vel.x=0;
      vel.y=0;
    }
  }
  void playerForces() {
    if(w) {
      //segments.remove(segments.size()-1);
    }
    if(s) {
      //segments.add(new HookSegment(player.pos.x, player.pos.y, index, segments.size()));
    }
    for(int i=segments.size()-1; i>-1; i--) {
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