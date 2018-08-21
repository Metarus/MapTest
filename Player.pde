class Player extends Entity {
  int hookCapacity=1;
  Player(float x, float y) {
    super(x, y, 2*blockWidth-10, 2*blockHeight-5, true);
  }
  void move() {
    addVel(0, 2);
    if(space&&touching[2]) addVel(0, -30);
    if(a&&touching[2]) addVel(-3, 0);
    if(a) addVel(-2, 0);
    if(d&&touching[2]) addVel(3,  0);
    if(d) addVel(2, 0);
    if(e) {
      if(hooks.size()<hookCapacity) {
        PVector hookVel=new PVector(mouseX-pos.x, mouseY-pos.y);
        hookVel.normalize();
        Hook hook=new Hook(pos.x+dim.x/2, pos.y+dim.y/2, 50*hookVel.x, 50*hookVel.y, hooks.size());
        hooks.add(hook);
      }
    }
    if(touching[2]) vel.x*=0.9;
    vel.x*=0.95;
  }
  void display() {
    fill(255, 0, 0);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
}