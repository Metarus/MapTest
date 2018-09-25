class Entity {
  PVector pos=new PVector(0, 0), dim=new PVector(0, 0), vel=new PVector(0, 0);
  float weight;
  boolean applyPhysics, touching[]=new boolean[4];
  ArrayList <PVector> touchingBlocks=new ArrayList<PVector>();
  Entity(float x, float y, float w, float h, float _weight, boolean _applyPhysics) {
    dim.x=w;
    dim.y=h;
    pos.x=x;
    pos.y=y;
    weight=_weight;
    applyPhysics=_applyPhysics;
  }
  void checkCollisions(int tag) {
    touchingBlocks.clear();
    PVector temp=vel;
    if(abs(temp.x)>blockWidth/1.3) temp.x=(blockWidth/1.3)*(temp.x/abs(vel.x));
    if(abs(temp.y)>blockHeight/1.3) temp.y=(blockHeight/1.3)*(temp.y/abs(vel.y));
    if(applyPhysics) {
      for(int i=0; i<touching.length; i++) {
        touching[i]=false;
      }
      int yBlock;
      if(temp.y>0) {
        yBlock=floor((pos.y+temp.y+dim.y)/(blockHeight));
      } else yBlock=floor((pos.y+temp.y)/(blockHeight)); 
      for(int i=0; i<floor(dim.x/(blockWidth))+2; i++) {
        if(i!=floor(dim.x/(blockWidth)+1)) {
          if(map.tags[map.mapNums[floor((pos.x)/blockWidth)+i][yBlock]][tag]) {
            touchingBlocks.add(new PVector(floor((pos.x)/blockWidth)+i, yBlock));
            touchingY(yBlock);
          }
        } else {
          if(map.tags[map.mapNums[floor((pos.x+dim.x)/blockWidth)][yBlock]][tag]) {
            touchingBlocks.add(new PVector(floor((pos.x+dim.x)/blockWidth), yBlock));
            touchingY(yBlock);
          }
        }
      }
      int xBlock;
      if(temp.x>0) {
        xBlock=floor((pos.x+temp.x+dim.x)/(blockWidth));
      } else xBlock=floor((pos.x+temp.x)/(blockWidth));
      for(int i=0; i<floor(dim.y/(blockHeight))+2; i++) {
        if(i!=floor(dim.y/(blockHeight)+1)) {
          //rect(xBlock*blockWidth, floor(((pos.y+temp.y)/blockHeight)+i)*blockHeight, blockWidth, blockHeight);
          if(map.tags[map.mapNums[xBlock][floor((pos.y+temp.y)/blockHeight)+i]][tag]) {
            touchingBlocks.add(new PVector(xBlock, floor((pos.y+temp.y)/blockHeight)+i));
            touchingX(xBlock);
          }
        } else {
          //rect(xBlock*blockWidth, floor((pos.y+temp.y+dim.y)/blockHeight)*blockHeight, blockWidth, blockHeight);
          if(map.tags[map.mapNums[xBlock][floor((pos.y+temp.y+dim.y)/blockHeight)]][tag]) {
            touchingBlocks.add(new PVector(xBlock, floor((pos.y+temp.y+dim.y)/blockHeight)));
            touchingX(xBlock);
          }
        }
      }
    }
  }
  void movement() {
    if(abs(vel.x)>blockWidth/1.3) vel.x=(blockWidth/1.3)*(vel.x/abs(vel.x));
    if(abs(vel.y)>blockHeight/1.3) vel.y=(blockHeight/1.3)*(vel.y/abs(vel.y));
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
  void addVel(float velX, float velY) {
    vel.x+=velX;
    vel.y+=velY;
  }
  void applyForce(float fX, float fY) {
    vel.x+=fX/weight;
    vel.y+=fY/weight;
  }
}