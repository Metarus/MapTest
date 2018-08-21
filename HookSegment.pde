class HookSegment extends Entity {
  int hookNum;
  int index;
  float len;
  HookSegment(float x, float y, float _len, int _hookNum, int _index) {
    super(x, y, 1, 1, true);
    hookNum=_hookNum;
    index=_index;
    len=_len;
  }
  void segUpdate() {
    if(index==hooks.get(hookNum).segments.size()-1) {
      float mag=0;
      PVector forces=new PVector(0, 0);
      PVector playerPos=new PVector(player.pos.x+player.vel.x+player.dim.x/2, player.pos.y+player.vel.y+player.dim.y/2);
      forces=new PVector((pos.x-playerPos.x), (pos.y-playerPos.y));
      forces.normalize();
      mag=(dist(playerPos.x, playerPos.y, pos.x, pos.y)-len);
      if(mag<0) mag=0;
      forces.x*=mag;
      forces.y*=mag;
      player.addVel(forces.x, forces.y);
      fill(0);
      line(pos.x, pos.y, player.pos.x+player.dim.x/2, player.pos.y+player.dim.y/2);
      if(w) len-=5;
      if(s) len+=5;
    } else {
      line(pos.x, pos.y, hooks.get(hookNum).segments.get(index+1).pos.x, hooks.get(hookNum).segments.get(index+1).pos.y);
    }
    for(int i=0; i<64; i++) {
      for(int j=0; j<64; j++) {
        if(map.tags[map.mapNums[i][j]][0]) {
          int check=hookRect(i, j);
          if(check!=0) {
            PVector newSeg=new PVector(0, 0);
            switch(check) {
              case 1:
                newSeg.x=i*blockWidth-5;
                newSeg.y=j*blockHeight-5;
                break;
              case 2:
                newSeg.x=(i+1)*blockWidth+5;
                newSeg.y=j*blockHeight-5;
                break;
              case 3:
                newSeg.x=(i+1)*blockWidth+5;
                newSeg.y=(j+1)*blockHeight+5;
                break;
              case 4:
                newSeg.x=i*blockWidth-5;
                newSeg.y=(j+1)*blockHeight+5;
                break;
            }
            hooks.get(hookNum).segments.add(new HookSegment(newSeg.x, newSeg.y, len-dist(newSeg.x, newSeg.y, pos.x, pos.y), hookNum, hooks.get(hookNum).segments.size()));
            len-=len-dist(newSeg.x, newSeg.y, pos.x, pos.y);
          }
        }
      }
    }
  }
  int hookRect(int bX, int bY) {
    boolean top=lineLine(pos.x, pos.y, player.pos.x, player.pos.y, bX*blockWidth, bY*blockHeight, (bX+1)*blockWidth, bY*blockHeight);
    boolean bottom=lineLine(pos.x, pos.y, player.pos.x, player.pos.y, bX*blockWidth, (bY+1)*blockHeight, (bX+1)*blockWidth, (bY+1)*blockHeight);
    boolean left=lineLine(pos.x, pos.y, player.pos.x, player.pos.y, bX*blockWidth, bY*blockHeight, bX*blockWidth, (bY+1)*blockHeight);
    boolean right=lineLine(pos.x, pos.y, player.pos.x, player.pos.y, (bX+1)*blockWidth, bY*blockHeight, (bX+1)*blockWidth, (bY+1)*blockHeight);
    if(top||bottom||left||right) {
      if(top&&left) return 1;
      if(top&&right) return 2;
      if(bottom&&right) return 3;
      if(bottom&&left) return 4;
      return 0;
    }
    return 0;
  }
  void display() {
    fill(0);
    rect(pos.x, pos.y, 5, 5);
  }
}