class Player extends Entity {
  int hookCapacity=1;
  Player(float x, float y) {
    super(x, y, 2*blockWidth-10, 2*blockHeight-5, true);
  }
  void move() {
    addVel(0, 2);
    if(space&&touching[2]) addVel(0, -30);
    if(a) addVel(-5, 0);
    if(d) addVel(5,  0);
    if(mousePressed) {
      if(hooks.size()<hookCapacity) {
        PVector hookVel=new PVector(mouseX-pos.x, mouseY-pos.y);
        hookVel.normalize();
        Hook hook=new Hook(pos.x, pos.y, 10*hookVel.x, 10*hookVel.y);
        hooks.add(hook);
      }
    }
    vel.x*=0.8;
  }
  void display() {
    fill(255, 0, 0);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
}