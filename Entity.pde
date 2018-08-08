class Entity {
  PVector pos=new PVector(0, 0), dim=new PVector(0, 0), vel=new PVector(0, 0);
  boolean applyPhysics, touching[]=new boolean[4];
  ArrayList <PVector> touchingBlocks=new ArrayList<PVector>();
  Entity(float x, float y, float w, float h, boolean _applyPhysics) {
    dim.x=w;
    dim.y=h;
    pos.x=x;
    pos.y=y;
    applyPhysics=_applyPhysics;
  }
  void update() {
    if(applyPhysics) {
      for(int i=0; i<touching.length; i++) {
        touching[i]=false;
      }
      int yBlock;
      if(vel.y>0) {
        yBlock=floor((pos.y+vel.y+dim.y)/(blockHeight));
      } else yBlock=floor((pos.y+vel.y)/(blockHeight)); 
      for(int i=0; i<floor(dim.x/(blockWidth))+2; i++) {
        if(i!=floor(dim.x/(blockWidth)+1)) {
          if(map.tags[map.mapNums[floor((pos.x)/blockWidth)+i][yBlock]][0]) {
            touchingBlocks.add(new PVector(floor((pos.x)/blockWidth)+i, yBlock));
            touchingY(yBlock);
          }
        } else {
          if(map.tags[map.mapNums[floor((pos.x+dim.x)/blockWidth)][yBlock]][0]) {
            touchingBlocks.add(new PVector(floor((pos.x+dim.x)/blockWidth), yBlock));
            touchingY(yBlock);
          }
        }
      }
      int xBlock;
      if(vel.x>0) {
        xBlock=floor((pos.x+vel.x+dim.x)/(blockWidth));
      } else xBlock=floor((pos.x+vel.x)/(blockWidth));
      for(int i=0; i<floor(dim.y/(blockHeight))+2; i++) {
        if(i!=floor(dim.y/(blockHeight)+1)) {
          //rect(xBlock*blockWidth, floor(((pos.y+vel.y)/blockHeight)+i)*blockHeight, blockWidth, blockHeight);
          if(map.tags[map.mapNums[xBlock][floor((pos.y+vel.y)/blockHeight)+i]][0]) {
            touchingBlocks.add(new PVector(xBlock, floor((pos.y+vel.y)/blockHeight)+i));
            touchingX(xBlock);
          }
        } else {
          //rect(xBlock*blockWidth, floor((pos.y+vel.y+dim.y)/blockHeight)*blockHeight, blockWidth, blockHeight);
          if(map.tags[map.mapNums[xBlock][floor((pos.y+vel.y+dim.y)/blockHeight)]][0]) {
            touchingBlocks.add(new PVector(xBlock, floor((pos.y+vel.y+dim.y)/blockHeight)));
            touchingX(xBlock);
          }
        }
      }
    }
    if(abs(vel.x)>blockWidth-5) vel.x=(blockWidth-2)*(vel.x/abs(vel.x));
    if(abs(vel.y)>blockHeight-5) vel.y=(blockHeight-2)*(vel.y/abs(vel.y));
    pos.x+=vel.x;
    pos.y+=vel.y;
  }
  void touchingY(float yBlock) {
    if(vel.y>0) touching[2]=true;
    if(vel.y<0) touching[0]=true;
    if(vel.y>0) pos.y=yBlock*blockHeight-dim.y-1;
    if(vel.y<0) pos.y=yBlock*blockHeight+blockHeight+1;
    vel.y=0;
  }
  void touchingX(float xBlock) {
    if(vel.x>0) touching[1]=true;
    if(vel.x<0) touching[3]=true;
    if(vel.x>0) pos.x=xBlock*blockWidth-dim.x-1;
    if(vel.x<0) pos.x=xBlock*blockWidth+blockWidth;
    vel.x=0;
  }
  void addVelVec(float mag, float angle) {
    vel.x+=mag*cos(angle);
    vel.y+=mag*sin(angle);
  }
  void addVel(float velX, float velY) {
    vel.x+=velX;
    vel.y+=velY;
  }
}