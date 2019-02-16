void loadData() {
  String str[]=loadStrings("map/save.txt");
  map=new Map("mapTiles.png", str[0], "tags.txt", 8, 8, 64, 64);
  player=new Player(parseInt(str[1]), parseInt(str[2]));
  player.hookCapacity=parseInt(str[3]);
}
void writeData() {
  PrintWriter writer1=createWriter("map/save.txt");
  writer1.print(map.mapLoc+"\n"+player.pos.x+"\n"+player.pos.y+"\n"+player.hookCapacity);
  writer1.flush();
  writer1.close();
}