void enterDoor(PVector block) {
  switch(map.mapLoc) {
    case "hub.txt": 
      if(rectDoor(block, 5, 13, 6, 15)) enterMap("lvl1.txt");
      if(rectDoor(block, 9, 13, 10, 15)) enterMap("lvl2.txt");
      break;
    case "lvl1.txt":
      if(rectDoor(block, 3, 13, 4, 15)) enterMap("hub.txt");
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