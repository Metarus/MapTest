ArrayList <Hook> hooks=new ArrayList<Hook>();
Player player;
Map map;

float blockWidth, blockHeight;
boolean w, a, s, d, e, q, up, down, left, right, space;
Camera cam=new Camera(new PVector(0, 0));

Hook hook;

boolean transition=false;
String transitionMap="";
PVector transPos;
int transTime=0, shift=32;
color transitionColor=color(0, 0, 0);

void setup() {
  noSmooth();
  size(1600, 900);
  
  blockWidth=width/32;
  blockHeight=height/18;
    
  map=new Map("mapTiles.png", "hub.txt", "tags.txt", 8, 8, 64, 64);
  player=new Player(width/2, height/2);
}

void draw() {
  map.display(-cam.pos.x, -cam.pos.y, width*2, height*2*64/36, 0, 0, 64, 64);
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
  if(transition) transition();
  if(q) hooks.clear();
  cam.update();
}

void keyPressed() {
  if(!transition) {
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
}

void keyReleased() {
  if(keyCode==UP||transition) up=false;
  if(keyCode==DOWN||transition) down=false;
  if(keyCode==LEFT||transition) left=false;
  if(keyCode==RIGHT||transition) right=false;
  if(key=='w'||transition) w=false;
  if(key=='a'||transition) a=false;
  if(key=='s'||transition) s=false;
  if(key=='d'||transition) d=false;
  if(key=='e'||transition) e=false;
  if(key=='q'||transition) q=false;
  if(key==' '||transition) space=false;
}

void transition() {
  transTime+=shift;
  fill(transitionColor, transTime);
  rect(0, 0, width, height);
  if(transTime>255) {
    shift=-32;
    map.readMap(transitionMap);
    player.reset();
    player.pos=transPos;
    cam.pos=new PVector(transPos.x-width, transPos.y-height);
  }
  if(transTime==0) {
    transition=false;
    shift=32;
  }
}

void enterMap(String name, PVector pos) {
  transitionMap=name;
  transPos=pos;
  transition=true;
}