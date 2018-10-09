class Hook extends Entity {
  boolean hit, kill;
  int index;
  ArrayList <HookSegment> segments=new ArrayList<HookSegment>();
  Hook(float x, float y, float velX, float velY, int _index) {
    super(x, y, 0.1*blockWidth, 0.1*blockHeight, 1, true);
    vel.x=velX;
    vel.y=velY;
    index=_index;
  }
  void hookUpdate() {
    checkCollisions(1);
    if(hit) playerForces();
    if(touchingBlocks.size()>0&&!hit) {
      PVector movement=new PVector(player.pos.x-pos.x, player.pos.y-pos.y);
      movement.normalize();
      for(int i=0; i<=dist(pos.x, pos.y, player.pos.x, player.pos.y)+30; i+=30) {
        segments.add(new HookSegment(pos.x+movement.x*i, pos.y+movement.y*i, index, i/30));
      }
      hit=true;
      vel.x=0;
      vel.y=0;
    }
    touchingBlocks.clear();
    checkCollisions(0);
    if(touchingBlocks.size()>0&&!hit) {
      kill=true;
    }
  }
  void playerForces() {
    if(w&&segments.size()>1) {
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
        segments.get(i).checkCollisions(0);
      }
    }
    for(int i=0; i<segments.size(); i++) {
      segments.get(i).segUpdate2();
      segments.get(i).checkCollisions(0);
    }
    for(int i=0; i<segments.size(); i++) {
      segments.get(i).movement();
      segments.get(i).display();
    }
  }
  void display() {
    gameSpace.fill(0, 255, 0);
    gameSpace.rect(pos.x, pos.y, dim.x, dim.y);
  }
}