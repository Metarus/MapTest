void enterDoor(PVector block) {
  transitionColor=color(0, 0, 0);
  switch(map.mapLoc) {
    case "hub.txt": 
      if(rectDoor(block, 5, 13, 6, 15)) enterMap("lvl1.txt", new PVector(blockWidth*3, blockHeight*15));
      if(rectDoor(block, 9, 13, 10, 15)) enterMap("lvl2.txt", new PVector(blockWidth*5, blockHeight*15));
      if(rectDoor(block, 13, 13, 14, 15)) enterMap("hub.txt", new PVector(blockWidth*17, blockHeight*15));
      if(rectDoor(block, 17, 13, 18, 15)) enterMap("hub.txt", new PVector(blockWidth*13, blockHeight*15));
      if(rectDoor(block, 21, 13, 22, 15)) enterMap("lvl2.txt", new PVector(blockWidth*12, blockHeight*38));
      break;
    case "lvl1.txt":
      if(rectDoor(block, 3, 13, 4, 15)) enterMap("hub.txt", new PVector(blockWidth*5, blockHeight*15));
      break;
      
    case "lvl2.txt":
      if(rectDoor(block, 12, 38, 13, 40)) enterMap("hub.txt", new PVector(blockWidth*21, blockHeight*15));
      break;
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