class Player extends Entity {
  PVector pos=new PVector(0, 0), vel=new PVector(0, 0);
  Player(float x, float y) {
    super(x, y, 2*blockWidth, 3*blockHeight, true);
  }
  void move() {
    if(w&&onGround) addVel(0, -30);
    if(a) addVel(-5, 0);
    if(s) addVel(0,  5);
    if(d) addVel(5,  0);
  }
}