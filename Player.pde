class Player extends Entity {
  int hookCapacity=1;
  Player(float x, float y) {
    super(x, y, 2*blockWidth-10, 2*blockHeight-5, 1, true);
  }
  void move() {
    getBlocks();
    addVel(0, 2);
    if(space&&touching[2]) addVel(0, -30);
    if(a&&touching[2]) addVel(-1, 0);
    if(a) addVel(-1, 0);
    if(d&&touching[2]) addVel(1,  0);
    if(d) addVel(1, 0);
    if(e) {
      if(hooks.size()<hookCapacity) {
        PVector hookVel=new PVector(mouseX+cam.pos.x-pos.x-dim.x/2, mouseY+cam.pos.y-pos.y-dim.y/2);
        hookVel.normalize();
        Hook hook=new Hook(pos.x+dim.x/2, pos.y+dim.y/2, 50*hookVel.x, 50*hookVel.y, hooks.size());
        hooks.add(hook);
      }
    }
    if(touching[2]) vel.x*=0.9;
    vel.x*=.95;
    getBlocks();
    if(w&&touching[2]) {
      for(int i=0; i<overBlocks.size(); i++) {
        if(map.checkTag(overBlocks.get(i), 3)) enterDoor(overBlocks.get(i));
      }
    }
    for(int i=0; i<overBlocks.size(); i++) {
      if(map.checkTag(overBlocks.get(i), 2)) {
        enterMap("hub.txt", new PVector(blockWidth*5, blockHeight*3));
        player.vel.x=0;
        player.vel.y=-30;
      }
    }
  }
  void display() {
    fill(255, 0, 0);
    rect(pos.x-cam.pos.x, pos.y-cam.pos.y, dim.x, dim.y);
  }
  void reset() {
    pos.x=width/2;
    pos.y=height/2;
    vel.x=0;
    vel.y=0;
    hooks.clear();
  }
}