class HookSegment extends Entity {
  int hookNum;
  int index;
  HookSegment(float x, float y, int _hookNum, int _index) {
    super(x, y, 1, 1, 0.00001, true);
    hookNum=_hookNum;
    index=_index;
  }
  PVector getForces() {
    float mag=0;
    float totalWeight=weight;
    PVector forces=new PVector(0, 0);
    PVector nextPos=new PVector(0, 0);
    if(index+1<hooks.get(hookNum).segments.size()) {
      HookSegment next=hooks.get(hookNum).segments.get(index+1);
      nextPos=new PVector(next.pos.x+next.vel.x+next.dim.x/2, next.pos.y+next.vel.y+next.dim.y/2);
      totalWeight+=weight;
    } else {
      nextPos=new PVector(player.pos.x+player.vel.x+player.dim.x/2, player.pos.y+player.vel.y+player.dim.y/2);
      totalWeight+=player.weight;
    }
    forces=new PVector((pos.x+vel.x-nextPos.x), (pos.y+vel.y-nextPos.y));
    forces.normalize();
    mag=dist(nextPos.x, nextPos.y, pos.x+vel.x, pos.y+vel.y)-30;
    if(mag<0) mag=0;
    return new PVector(forces.x*mag*totalWeight/2.1, forces.y*mag*totalWeight/2.1);
  }
  void seg() {
    if(index!=0) addVel(0, 2);
  }
  void segUpdate1() {
    PVector forces=getForces();
    if(index+1<hooks.get(hookNum).segments.size()) {
      hooks.get(hookNum).segments.get(index+1).applyForce(forces.x, forces.y);
    }
    if(index!=0) {
      applyForce(-forces.x, -forces.y);
    }
  }
  void segUpdate2() {
    PVector forces=getForces();
    if(index+1<hooks.get(hookNum).segments.size()) {
      hooks.get(hookNum).segments.get(index+1).applyForce(forces.x, forces.y);
    } else {
      player.applyForce(forces.x, forces.y);
    }
    vel.x*=0.9;
    vel.y*=0.9;
  }
  void display() {
    fill(0);
    rect(pos.x, pos.y, 5, 5);
  }
}