ArrayList <Hook> hooks=new ArrayList<Hook>();
Player player;
Map map;

float blockWidth, blockHeight;
boolean w, a, s, d, e, q, up, down, left, right, space;
Camera cam=new Camera(new PVector(0, 0));

Hook hook;

void setup() {
  noSmooth();
  size(1600, 900);
  
  blockWidth=width/32;
  blockHeight=height/18;
    
  map=new Map("mapTiles.png", "hub.txt", "tags.txt", 8, 8, 64, 64);
  player=new Player(width/2, height/2);
}

void draw() {
  map.display(0, 0, width*2, height*2, 0, 0, 64, 36);
  for(int i=0; i<hooks.size(); i++) {
    hooks.get(i).movement();
    hooks.get(i).hookUpdate();
    hooks.get(i).display();
    if(hooks.get(i).kill) {
      hooks.remove(i);
      i--;
    }
  }
  player.move();
  player.checkCollisions(0, true);
  player.movement();
  player.display();
  if(q) hooks.clear();
  cam.update();
}

void keyPressed() {
  if(keyCode==UP) up=true;
  if(keyCode==DOWN) down=true;
  if(keyCode==LEFT) left=true;
  if(keyCode==RIGHT) right=true;
  if(key=='w') w=true;
  if(key=='a') a=true;
  if(key=='s') s=true;
  if(key=='d') d=true;
  if(key=='e') e=true;
  if(key=='q') q=true;
  if(key==' ') space=true;
}

void keyReleased() {
  if(keyCode==UP) up=false;
  if(keyCode==DOWN) down=false;
  if(keyCode==LEFT) left=false;
  if(keyCode==RIGHT) right=false;
  if(key=='w') w=false;
  if(key=='a') a=false;
  if(key=='s') s=false;
  if(key=='d') d=false;
  if(key=='e') e=false;
  if(key=='q') q=false;
  if(key==' ') space=false;
}

void enterMap(String name) {
  map.readMap(name);
  player.reset();
  cam.pos=new PVector(0, 0);
}