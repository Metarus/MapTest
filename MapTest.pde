ArrayList <Hook> hooks=new ArrayList<Hook>();
Player player;
Map map;

float blockWidth, blockHeight;
boolean w, a, s, d, space;

Hook hook;

void setup() {
  noSmooth();
  size(1600, 900);
  //fullScreen();
  
  blockWidth=width/32;
  blockHeight=height/18;
    
  map=new Map("map/mapTiles.png", "map/map.txt", "map/tags.txt", 8, 8, 64, 64);
  player=new Player(width/2, height/2);
}

void draw() {
  map.display(0, 0, width, height, 0, 0, 32, 18);
  player.move();
  player.update();
  for(int i=0; i<hooks.size(); i++) {
    hooks.get(i).update();
    hooks.get(i).hookUpdate();
    hooks.get(i).display();
  }
  player.display();
}

void keyPressed() {
  if(key=='w') w=true;
  if(key=='a') a=true;
  if(key=='s') s=true;
  if(key=='d') d=true;
  if(key==' ') space=true;
}

void keyReleased() {
  if(key=='w') w=false;
  if(key=='a') a=false;
  if(key=='s') s=false;
  if(key=='d') d=false;
  if(key==' ') space=false;
}