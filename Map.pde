class Map {
  int tileWidth, tagNum;
  int[][] mapNums;
  boolean[][] tags;

  PImage sprites[];
  String mapLoc, tagLoc;
  
  Map(String _spriteSheet, String _map, String _tags, int _tileWidth, int _tagNum, int w, int h) {
    PImage spriteSheet;
    spriteSheet=loadImage(_spriteSheet);
    
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
  
  void display(float x, float y, float w, float h, int startX, int startY, int endX, int endY) {
    PGraphics map=createGraphics((endX-startX)*tileWidth, (endY-startY)*tileWidth);
    map.beginDraw();
    for(int i=startX; i<endX; i++) {
      for(int j=startY; j<endY; j++) {
        map.image(sprites[mapNums[i][j]], i*tileWidth, j*tileWidth);
      }
    }
    map.endDraw();
    gameSpace.image(map, x, y, w, h);
  }
  
  void writeData() {
  PrintWriter writer1=createWriter(mapLoc);
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
    
    PrintWriter writer2=createWriter(tagLoc);
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
  
  void readData() {
    String str1[]=loadStrings(mapLoc);
    if(str1.length!=0) {
      str1=split(str1[0], '.');
      String strings1[][]=new String[str1.length][];
      for(int i=0; i<str1.length-1; i++) {
        strings1[i]=split(str1[i],',');
        for(int j=0; j<strings1[i].length-1; j++) {
          mapNums[i][j]=int(strings1[i][j]);
        }
      }
    }
    String str2[]=loadStrings(tagLoc);
    if(str2.length!=0) {
    str2=split(str2[0], '.');
      String strings2[][]=new String[str2.length][];
      for(int i=0; i<str2.length-1; i++) {
        strings2[i]=split(str2[i],',');
        for(int j=0; j<strings2[i].length-1; j++) {
          tags[i][j]=boolean(int(strings2[i][j]));
        }
      }
    }
  }
}