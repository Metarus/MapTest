class HookSegment extends Entity {
  int hookNum;
  int index;
  HookSegment(float x, float y, int _hookNum, int _index) {
    super(x, y, 1, 1, true);
    hookNum=_hookNum;
    index=_index;
  }
  void segUpdate() {
    if(index!=0) addVel(0, 2);
    float mag=0;
    PVector forces=new PVector(0, 0);
    if(index+1<hooks.get(hookNum).segments.size()) {
      PVector segPos=new PVector(hooks.get(hookNum).segments.get(index+1).pos.x+hooks.get(hookNum).segments.get(index+1).vel.x, hooks.get(hookNum).segments.get(index+1).pos.y+hooks.get(hookNum).segments.get(index+1).vel.y);
      forces=new PVector((pos.x-segPos.x), (pos.y-segPos.y));
      forces.normalize();
      mag=dist(segPos.x, segPos.y, pos.x, pos.y)-10;
    } else {
      PVector playerPos=new PVector(player.pos.x+player.vel.x, player.pos.y+player.vel.y);
      forces=new PVector((pos.x-playerPos.x), (pos.y-playerPos.y));
      forces.normalize();
      mag=dist(playerPos.x, playerPos.y, pos.x, pos.y)-10;
    }
    if(mag<0) mag=0;
    forces.x*=mag;
    forces.y*=mag;
    if(index+1<hooks.get(hookNum).segments.size()) {
      hooks.get(hookNum).segments.get(index+1).addVel(forces.x, forces.y);
    } else {
      println(forces.x);
      player.addVel(forces.x, forces.y);
    }
    if(index!=0) {
      addVel(-forces.x, -forces.y);
    }
    hooks.get(hookNum);
  }
  void display() {
    fill(0);
    rect(pos.x, pos.y, 5, 5);
  }
}