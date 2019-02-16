import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MapTest extends PApplet {

ArrayList <Hook> hooks=new ArrayList<Hook>();
Player player;
Map map;

float blockWidth, blockHeight;
boolean w, a, s, d, e, q, r, f, t, g, up, down, left, right, space;
Camera cam=new Camera(new PVector(0, 0));

Hook hook;

boolean transition=false;
String transitionMap="";
PVector transPos;
int transTime=0, shift=32, doorFunc=0;
int transitionColor=color(0, 0, 0);

public void setup() {
  
  
  
  blockWidth=width/32;
  blockHeight=height/18;
    
  loadData();
}

public void draw() {
  background(255);
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
  displayText();
}

public void keyPressed() {
  if(!transition) {
    if(keyCode==UP) up=true;
    if(keyCode==DOWN) down=true;
    if(keyCode==LEFT) left=true;
    if(keyCode==RIGHT) right=true;
    if(key=='w') w=true;
    if(key=='a') a=true;
    if(key=='s') s=true;
    if(key=='d') d=true;
    if(key=='r') r=true;
    if(key=='f') f=true;
    if(key=='t') t=true;
    if(key=='g') g=true;
    if(key=='e') e=true;
    if(key=='q') q=true;
    if(key==' ') space=true;
  }
  if(key=='o') {
    writeData();
    exit();
  }
}

public void keyReleased() {
  if(keyCode==UP||transition) up=false;
  if(keyCode==DOWN||transition) down=false;
  if(keyCode==LEFT||transition) left=false;
  if(keyCode==RIGHT||transition) right=false;
  if(key=='w'||transition) w=false;
  if(key=='a'||transition) a=false;
  if(key=='s'||transition) s=false;
  if(key=='d'||transition) d=false;
  if(key=='r'||transition) r=false;
  if(key=='f'||transition) f=false;
  if(key=='t'||transition) t=false;
  if(key=='g'||transition) g=false;
  if(key=='e'||transition) e=false;
  if(key=='q'||transition) q=false;
  if(key==' '||transition) space=false;
}

public void transition() {
  transTime+=shift;
  fill(transitionColor, transTime);
  rect(0, 0, width, height);
  if(transTime>255) {
    shift=-32;
    map.readMap(transitionMap);
    player.reset();
    player.pos=transPos;
    cam.pos=new PVector(transPos.x-width, transPos.y-height);
    doorFunc(doorFunc);
    doorFunc=0;
  }
  if(transTime==0) {
    transition=false;
    shift=32;
  }
}

public void enterMap(String name, PVector pos, int _doorFunc) {
  enterMap(name, pos);
  doorFunc=_doorFunc;
}
public void enterMap(String name, PVector pos) {
  transitionMap=name;
  transPos=pos;
  transition=true;
}
class Camera {
  PVector pos;
  Camera(PVector start) {
    pos=start;
  }
  public void update() {
    if(up) pos.y-=10;
    if(down) pos.y+=10;
    if(left) pos.x-=10;
    if(right) pos.x+=10;
    while(player.pos.x-pos.x-width/2-5*blockWidth>0) {
      pos.x++;
    }
    while(player.pos.x-pos.x-width/2+5*blockWidth<0) {
      pos.x--;
    }
    while(player.pos.y-pos.y-height/2-6*blockWidth>0) {
      pos.y++;
    }
    while(player.pos.y-pos.y-height/2+6*blockWidth<0) {
      pos.y--;
    }
    if(pos.x<0) pos.x=0;
    if(pos.y<0) pos.y=0;
  }
}
class Entity {
  PVector pos=new PVector(0, 0), dim=new PVector(0, 0), vel=new PVector(0, 0);
  float weight;
  boolean applyPhysics, touching[]=new boolean[4];
  ArrayList <PVector> touchingBlocks=new ArrayList<PVector>();
  ArrayList <PVector> overBlocks=new ArrayList<PVector>();
  Entity(float x, float y, float w, float h, float _weight, boolean _applyPhysics) {
    dim.x=w;
    dim.y=h;
    pos.x=x;
    pos.y=y;
    weight=_weight;
    applyPhysics=_applyPhysics;
  }
  public void checkCollisions(int tag, boolean phys) {
    touchingBlocks.clear();
    PVector temp=vel;
    if(abs(temp.x)>blockWidth/1.3f) temp.x=(blockWidth/1.3f)*(temp.x/abs(vel.x));
    if(abs(temp.y)>blockHeight/1.3f) temp.y=(blockHeight/1.3f)*(temp.y/abs(vel.y));
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
            touchingY(yBlock, phys);
          }
        } else {
          if(map.tags[map.mapNums[floor((pos.x+dim.x)/blockWidth)][yBlock]][tag]) {
            touchingBlocks.add(new PVector(floor((pos.x+dim.x)/blockWidth), yBlock));
            touchingY(yBlock, phys);
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
            touchingX(xBlock, phys);
          }
        } else {
          //rect(xBlock*blockWidth, floor((pos.y+temp.y+dim.y)/blockHeight)*blockHeight, blockWidth, blockHeight);
          if(map.tags[map.mapNums[xBlock][floor((pos.y+temp.y+dim.y)/blockHeight)]][tag]) {
            touchingBlocks.add(new PVector(xBlock, floor((pos.y+temp.y+dim.y)/blockHeight)));
            touchingX(xBlock, phys);
          }
        }
      }
    }
  }
  public void getBlocks() {
    overBlocks.clear();
    for(int i=(int)(pos.x/blockWidth); i<=(int)((dim.x+pos.x)/blockWidth); i++) {
      for(int j=(int)(pos.y/blockHeight); j<=(int)((dim.y+pos.y)/blockHeight); j++) {
        overBlocks.add(new PVector(i, j));
      }
    }
  }
  public void movement() {
    if(abs(vel.x)>blockWidth/1.3f) vel.x=(blockWidth/1.3f)*(vel.x/abs(vel.x));
    if(abs(vel.y)>blockHeight/1.3f) vel.y=(blockHeight/1.3f)*(vel.y/abs(vel.y));
    pos.x+=vel.x;
    pos.y+=vel.y;
  }
  public void touchingY(float yBlock, boolean phys) {
    if(vel.y>0) touching[2]=true;
    if(vel.y<0) touching[0]=true;
    if(phys) {
      if(vel.y>0) pos.y=yBlock*blockHeight-dim.y-1;
      if(vel.y<0) pos.y=yBlock*blockHeight+blockHeight+1;
      vel.y=0;
    }
  }
  public void touchingX(float xBlock, boolean phys) {
    if(vel.x>0) touching[1]=true;
    if(vel.x<0) touching[3]=true;
    if(phys) {
      if(vel.x>0) pos.x=xBlock*blockWidth-dim.x-1;
      if(vel.x<0) pos.x=xBlock*blockWidth+blockWidth;
      vel.x=0;
    }
  }
  public void addVel(float velX, float velY) {
    vel.x+=velX;
    vel.y+=velY;
  }
  public void applyForce(float fX, float fY) {
    vel.x+=fX/weight;
    vel.y+=fY/weight;
  }
}
class Hook extends Entity {
  boolean hit, kill;
  int index;
  ArrayList <HookSegment> segments=new ArrayList<HookSegment>();
  Hook(float x, float y, float velX, float velY, int _index) {
    super(x, y, 0.1f*blockWidth, 0.1f*blockHeight, 1, true);
    vel.x=velX;
    vel.y=velY;
    index=_index;
  }
  public void hookUpdate() {
    checkCollisions(1, true);
    if(hit) playerForces();
    if(touchingBlocks.size()>0&&!hit) {
      PVector movement=new PVector(player.pos.x-pos.x, player.pos.y-pos.y);
      movement.normalize();
      for(int i=0; i<=dist(pos.x, pos.y, player.pos.x, player.pos.y)+30; i+=20) {
        segments.add(new HookSegment(pos.x+movement.x*i, pos.y+movement.y*i, index, i/20));
      }
      hit=true;
      vel.x=0;
      vel.y=0;
    }
    touchingBlocks.clear();
    checkCollisions(0, true);
    if(touchingBlocks.size()>0&&!hit) {
      kill=true;
    }
  }
  public void playerForces() {
    if((w||(r&&index==0)||(t&&index==1))&&segments.size()>1) {
      if(dist(segments.get(segments.size()-1).pos.x, segments.get(segments.size()-1).pos.y, player.pos.x+player.dim.x/2, player.pos.y+player.dim.y/2)<50) {
        segments.remove(segments.size()-1);
      } else {
        player.addVel(0, -5);
      }
    }
    if((s||(f&&index==0)||(g&&index==1))&&segments.size()<100) {
      segments.add(new HookSegment(player.pos.x, player.pos.y, index, segments.size()));
    }
    for(int i=segments.size()-1; i>=0; i--) {
      segments.get(i).seg();
    }
    for(int j=0; j<5; j++) {
      for(int i=segments.size()-1; i>=0; i--) {
        segments.get(i).segUpdate1();
        segments.get(i).checkCollisions(0, true);
      }
    }
    for(int i=0; i<segments.size(); i++) {
      segments.get(i).segUpdate2();
      segments.get(i).checkCollisions(0, true);
    }
    for(int i=0; i<segments.size(); i++) {
      segments.get(i).movement();
      segments.get(i).display();
    }
  }
  public void display() {
    fill(0, 255, 0);
    if(!hit) {
      strokeWeight(3);
      line(pos.x-cam.pos.x, pos.y-cam.pos.y, player.pos.x-cam.pos.x+player.dim.x/2, player.pos.y-cam.pos.y+player.dim.y/2);
      strokeWeight(1);
    }
    rect(pos.x-cam.pos.x, pos.y-cam.pos.y, dim.x, dim.y);
  }
}
class HookSegment extends Entity {
  int hookNum;
  int index;
  HookSegment(float x, float y, int _hookNum, int _index) {
    super(x, y, 1, 1, 0.00001f, true);
    hookNum=_hookNum;
    index=_index;
  }
  public PVector getForces() {
    float mag=0;
    float totalWeight=weight;
    PVector forces=new PVector(0, 0);
    PVector nextPos=new PVector(0, 0);
    if(index+1<hooks.get(hookNum).segments.size()) {
      HookSegment next=hooks.get(hookNum).segments.get(index+1);
      nextPos=new PVector(next.pos.x+next.vel.x+next.dim.x/2, next.pos.y+next.vel.y+next.dim.y/2);
      totalWeight+=weight;
    } else {
      nextPos=new PVector(player.pos.x+player.vel.x+player.dim.x/2, player.pos.y+player.vel.y+player.dim.y/2);
      totalWeight+=player.weight;
    }
    forces=new PVector((pos.x+vel.x-nextPos.x), (pos.y+vel.y-nextPos.y));
    forces.normalize();
    mag=dist(nextPos.x, nextPos.y, pos.x+vel.x, pos.y+vel.y)-20;
    if(mag<0) mag=0;
    return new PVector(forces.x*mag*totalWeight/2.1f, forces.y*mag*totalWeight/2.1f);
  }
  public void seg() {
    if(index!=0) addVel(0, 2);
  }
  public void segUpdate1() {
    PVector forces=getForces();
    if(index+1<hooks.get(hookNum).segments.size()) {
      hooks.get(hookNum).segments.get(index+1).applyForce(forces.x, forces.y);
    }
    if(index!=0) {
      applyForce(-forces.x, -forces.y);
    }
  }
  public void segUpdate2() {
    PVector forces=getForces();
    if(index+1<hooks.get(hookNum).segments.size()) {
      hooks.get(hookNum).segments.get(index+1).applyForce(forces.x, forces.y);
    } else {
      player.applyForce(forces.x, forces.y);
    }
    vel.x*=0.9f;
    vel.y*=0.9f;
  }
  public void display() {
    fill(0);
    strokeWeight(3);
    if(index!=0) line(pos.x-cam.pos.x+1, pos.y-cam.pos.y+1, hooks.get(hookNum).segments.get(index-1).pos.x-cam.pos.x+1, hooks.get(hookNum).segments.get(index-1).pos.y-cam.pos.y+1);
    strokeWeight(1);
  }
}
class Map {
  int tileWidth, tagNum;
  int[][] mapNums;
  boolean[][] tags;

  PImage sprites[];
  String mapLoc, tagLoc;
  
  Map(String _spriteSheet, String _map, String _tags, int _tileWidth, int _tagNum, int w, int h) {
    PImage spriteSheet;
    spriteSheet=loadImage("map/"+_spriteSheet);
    
    tileWidth=_tileWidth;
    tagNum=_tagNum;
    mapLoc=_map;
    tagLoc=_tags;
    
    sprites=new PImage[spriteSheet.width/tileWidth*spriteSheet.height/tileWidth];
    for(int i=0; i<sprites.length; i++) {
      sprites[i]=spriteSheet.get(tileWidth*i%spriteSheet.width, tileWidth*floor(tileWidth*i/spriteSheet.width), tileWidth, tileWidth);
    }
  
    mapNums=new int[w][h];
    tags=new boolean[sprites.length][tagNum];
    readData();
  }
  
  public boolean checkTag(PVector pos, int tagNum) {
    return tags[mapNums[(int)pos.x][(int)pos.y]][tagNum];
  }
  
  public void fillRegion(int block, int x1, int y1, int x2, int y2) {
    for(int i=x1; i<=x2; i++) {
      for(int j=y1; j<=y2; j++) {
        mapNums[i][j]=block;
      }
    }
    writeData();
  }
  
  public void display(float x, float y, float w, float h, int startX, int startY, int endX, int endY) {
    PGraphics map=createGraphics((endX-startX)*tileWidth, (endY-startY)*tileWidth);
    map.beginDraw();
    for(int i=startX; i<endX; i++) {
      for(int j=startY; j<endY; j++) {
        map.image(sprites[mapNums[i][j]], i*tileWidth, j*tileWidth);
      }
    }
    map.endDraw();
    image(map, x, y, w, h);
  }
  
  public void writeData() {
    PrintWriter writer1=createWriter("map/"+mapLoc);
    String write1="";
    for(int i=0; i<mapNums.length; i++) {
      for(int j=0; j<mapNums[i].length; j++) {
        write1+=mapNums[i][j]+",";
      }
      write1+=".";
    }
    writer1.print(write1);
    writer1.flush();
    writer1.close();
    
    PrintWriter writer2=createWriter("map/"+tagLoc);
    String write2="";
    for(int i=0; i<tags.length; i++) {
      for(int j=0; j<tags[i].length; j++) {
        if(tags[i][j]) {
          write2+="1,";
        } else write2+="0,";
      }
      write2+=".";
    }
    writer2.print(write2);
    writer2.flush();
    writer2.close();
  }
  
  public void readMap(String name) {
    String str1[]=loadStrings("map/"+name);
    if(str1.length!=0) {
      str1=split(str1[0], '.');
      String strings1[][]=new String[str1.length][];
      for(int i=0; i<str1.length-1; i++) {
        strings1[i]=split(str1[i],',');
        for(int j=0; j<strings1[i].length-1; j++) {
          mapNums[i][j]=PApplet.parseInt(strings1[i][j]);
        }
      }
    }
    mapLoc=name;
  }
  
  public void readData() {
    readMap(mapLoc);
    String str2[]=loadStrings("map/"+tagLoc);
    if(str2.length!=0) {
    str2=split(str2[0], '.');
      String strings2[][]=new String[str2.length][];
      for(int i=0; i<str2.length-1; i++) {
        strings2[i]=split(str2[i],',');
        for(int j=0; j<strings2[i].length-1; j++) {
          tags[i][j]=PApplet.parseBoolean(PApplet.parseInt(strings2[i][j]));
        }
      }
    }
  }
}
public void enterDoor(PVector block) {
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
public void doorFunc(int n) {
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
public void displayText() {
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
      text("Congrats! That's the first level!", blockWidth*6.5f-cam.pos.x, blockHeight*20-cam.pos.y);
      break;
    case "hub.txt":
      text("Lvl 1", blockWidth*6.1f-cam.pos.x, blockHeight*13.5f-cam.pos.y);
      text("Lvl 2", blockWidth*11.1f-cam.pos.x, blockHeight*13.5f-cam.pos.y);
      text("Lvl 3", blockWidth*16.1f-cam.pos.x, blockHeight*13.5f-cam.pos.y);
      text("Lvl 4", blockWidth*26.5f-cam.pos.x, blockHeight*13.5f-cam.pos.y);
  }
}
public boolean rectDoor(PVector loc, int x1, int y1, int x2, int y2) {
  for(int i=x1; i<x2+1; i++) {
    for(int j=y1; j<y2+1; j++) {
      if(loc.x==i&&loc.y==j) {
        return true;
      }
    }
  }
  return false;
}
public boolean pvecLoc(PVector loc, int[] x, int[] y) {
  for(int i=0; i<x.length&&i<y.length; i++) {
    if(x[i]==loc.x&&y[i]==loc.y) {
      return true;
    }
  }
  return false;
}
class Player extends Entity {
  int hookCapacity=1;
  int hookDelay=0;
  Player(float x, float y) {
    super(x, y, 2*blockWidth-10, 2*blockHeight-5, 1, true);
  }
  public void move() {
    getBlocks();
    addVel(0, 2);
    if(space&&touching[2]) addVel(0, -30);
    if(a&&touching[2]) addVel(-1, 0);
    if(a) addVel(-1, 0);
    if(d&&touching[2]) addVel(1,  0);
    if(d) addVel(1, 0);
    if(hookDelay>0) hookDelay--;
    if(e) {
      if(hooks.size()<hookCapacity&&hookDelay==0) {
        PVector hookVel=new PVector(mouseX+cam.pos.x-pos.x-dim.x/2, mouseY+cam.pos.y-pos.y-dim.y/2);
        hookVel.normalize();
        Hook hook=new Hook(pos.x+dim.x/2, pos.y+dim.y/2, 50*hookVel.x, 50*hookVel.y, hooks.size());
        hooks.add(hook);
        hookDelay=30;
      }
    }
    if(touching[2]) vel.x*=0.9f;
    vel.x*=.95f;
    getBlocks();
    if(w&&touching[2]) {
      for(int i=0; i<overBlocks.size(); i++) {
        if(map.checkTag(overBlocks.get(i), 3)) enterDoor(overBlocks.get(i));
      }
    }
    for(int i=0; i<overBlocks.size(); i++) {
      if(map.checkTag(overBlocks.get(i), 2)) {
        transitionColor=color(255, 0, 0);
        enterMap(map.mapLoc, new PVector(blockWidth*5, blockHeight*3));
        player.vel.x=0;
        player.vel.y=-30;
      }
    }
  }
  public void display() {
    fill(255, 0, 0);
    rect(pos.x-cam.pos.x, pos.y-cam.pos.y, dim.x, dim.y);
  }
  public void reset() {
    pos.x=width/2;
    pos.y=height/2;
    vel.x=0;
    vel.y=0;
    hooks.clear();
  }
}
public void loadData() {
  String str[]=loadStrings("map/save.txt");
  map=new Map("mapTiles.png", str[0], "tags.txt", 8, 8, 64, 64);
  player=new Player(parseInt(str[1]), parseInt(str[2]));
  player.hookCapacity=parseInt(str[3]);
}
public void writeData() {
  PrintWriter writer1=createWriter("map/save.txt");
  writer1.print(map.mapLoc+"\n"+player.pos.x+"\n"+player.pos.y+"\n"+player.hookCapacity);
  writer1.flush();
  writer1.close();
}
class Text {
  String content="";
  PVector pos;
  boolean showing=false;
  Text(String str, float x, float y) {
    content=str;
    pos=new PVector(x, y);
  }
  
}
  public void settings() {  size(1600, 900);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MapTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
