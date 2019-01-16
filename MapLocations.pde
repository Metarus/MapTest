void enterDoor(PVector block) {
  transitionColor=color(0, 0, 0);
  switch(map.mapLoc) {
    case "hub.txt": 
      if(rectDoor(block, 5, 13, 6, 15)) enterMap("lvl1.txt", new PVector(blockWidth*3, blockHeight*15));
      if(rectDoor(block, 10, 13, 11, 15)) enterMap("lvl2.txt", new PVector(blockWidth*5, blockHeight*15));
      if(rectDoor(block, 15, 13, 16, 15)) enterMap("lvl3.txt", new PVector(blockWidth*17, blockHeight*15));
      if(rectDoor(block, 20, 13, 21, 15)) enterMap("hub.txt", new PVector(blockWidth*13, blockHeight*15));
      break;
    case "lvl1.txt":
      if(rectDoor(block, 2, 26, 3, 28)) enterMap("hub.txt", new PVector(blockWidth*5, blockHeight*15), 1);
      if(rectDoor(block, 33, 26, 34, 28)) enterMap("lvl1.txt", new PVector(blockWidth*28, blockHeight*26));
      if(rectDoor(block, 28, 26, 29, 28)) enterMap("lvl1.txt", new PVector(blockWidth*33, blockHeight*26));
      break;
      
    case "lvl2.txt":
      if(rectDoor(block, 20, 1, 21, 3)) enterMap("lvl2.txt", new PVector(blockWidth*23, blockHeight*2));
      if(rectDoor(block, 23, 1, 24, 3)) enterMap("lvl2.txt", new PVector(blockWidth*20, blockHeight*2));
      if(rectDoor(block, 58, 14, 59, 16)) enterMap("hub.txt", new PVector(blockWidth*10, blockHeight*15), 2);
      break;
      
    case "lvl3.txt":
      if(rectDoor(block, 12, 38, 13, 40)) enterMap("hub.txt", new PVector(blockWidth*15, blockHeight*15), 3);
      break;
  }
}
void doorFunc(int n) {
  switch(n) {
    case 1:
      map.fillRegion(0, 8, 14, 8, 16);
      break;
    case 2:
      map.fillRegion(0, 13, 14, 13, 16);
      break;
    case 3:
      map.fillRegion(0, 18, 14, 18, 16);
      player.hookCapacity=2;
      break;
  }
}
void displayText() {
  textAlign(CENTER);
  textSize(30);
  fill(0);
  switch(map.mapLoc) {
    case "lvl1.txt":
      text("Use A and D to move", blockWidth*7-cam.pos.x, blockHeight*2-cam.pos.y);
      text("Press E to use your hook and Q to release", blockWidth*30-cam.pos.x, blockHeight*4-cam.pos.y);
      text("Use W and S to change the length of your rope", blockWidth*30-cam.pos.x, blockHeight*5-cam.pos.y);
      text("Some blocks are hookable", blockWidth*43-cam.pos.x, blockHeight*12-cam.pos.y);
      text("Some blocks you can pass through", blockWidth*43-cam.pos.x, blockHeight*13-cam.pos.y);
      text("Arrow keys look around", blockWidth*56-cam.pos.x, blockHeight*5-cam.pos.y);
      text("Don't jump blindly", blockWidth*56-cam.pos.x, blockHeight*6-cam.pos.y);
      text("The black blocks will kill you!", blockWidth*56-cam.pos.x, blockHeight*20-cam.pos.y);
      text("Press W to enter doors", blockWidth*37-cam.pos.x, blockHeight*20-cam.pos.y);
      text("Congrats! That's the first level!", blockWidth*6.5-cam.pos.x, blockHeight*20-cam.pos.y);
      break;
    case "hub.txt":
      text("Lvl 1", blockWidth*6.1-cam.pos.x, blockHeight*13.5-cam.pos.y);
      text("Lvl 2", blockWidth*11.1-cam.pos.x, blockHeight*13.5-cam.pos.y);
      text("Lvl 3", blockWidth*16.1-cam.pos.x, blockHeight*13.5-cam.pos.y);
      text("Lvl 4", blockWidth*26.5-cam.pos.x, blockHeight*13.5-cam.pos.y);
  }
}
boolean rectDoor(PVector loc, int x1, int y1, int x2, int y2) {
  for(int i=x1; i<x2+1; i++) {
    for(int j=y1; j<y2+1; j++) {
      if(loc.x==i&&loc.y==j) {
        return true;
      }
    }
  }
  return false;
}
boolean pvecLoc(PVector loc, int[] x, int[] y) {
  for(int i=0; i<x.length&&i<y.length; i++) {
    if(x[i]==loc.x&&y[i]==loc.y) {
      return true;
    }
  }
  return false;
}