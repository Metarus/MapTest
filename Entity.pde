class Entity {
  PVector pos=new PVector(0, 0), dim=new PVector(0, 0), vel=new PVector(0, 0);
  boolean applyPhysics, onGround;
  Entity(float x, float y, float w, float h, boolean _applyPhysics) {
    dim.x=w;
    dim.y=h;
    pos.x=x;
    pos.y=y;
    applyPhysics=_applyPhysics;
  }
  void update() {
    onGround=false;
    if(applyPhysics) {
      addVel(0, 2);
      int yBlock;
      if(vel.y>0) {
        yBlock=floor((pos.y+vel.y+dim.y)/(blockHeight));
      } else yBlock=floor((pos.y+vel.y)/(blockHeight)); 
      for(int i=0; i<floor(dim.x/(blockWidth))+2; i++) {
        if(i!=floor(dim.x/(blockWidth)+1)) {
          if(map.tags[map.mapNums[floor((pos.x)/blockWidth)+i][yBlock]][0]) {
            if(vel.y>=0) onGround=true;
            vel.y=0;
          }
        } else {
          if(map.tags[map.mapNums[floor((pos.x+dim.x)/blockWidth)][yBlock]][0]) {
            if(vel.y>=0) onGround=true;
            vel.y=0;
          }
        }
      }
      int xBlock;
      if(vel.x>0) {
        xBlock=floor((pos.x+vel.x+dim.x)/(blockWidth));
      } else xBlock=floor((pos.x+vel.x)/(blockWidth));
      for(int i=0; i<floor(dim.y/(blockHeight))+2; i++) {
        if(i!=floor(dim.y/(blockHeight)+1)) {
          if(map.tags[map.mapNums[xBlock][floor((pos.y)/blockHeight)+i]][0]) {
            vel.x=0;
          }
        } else {
          if(map.tags[map.mapNums[xBlock][floor((pos.y+dim.y)/blockHeight)]][0]) {
            vel.x=0;
          }
        }
      }
    }
    vel.x*=0.8;
    pos.x+=vel.x;
    pos.y+=vel.y;
  }
  
  void display() {
    fill(255, 0, 0);
    rect(pos.x, pos.y, dim.x, dim.y);
  }
  
  void addVel(float velX, float velY) {
    vel.x+=velX;
    vel.y+=velY;
  }
}