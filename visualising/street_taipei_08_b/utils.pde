import java.util.Arrays;

void coordinateTransform() {
  translate(0,height);
  scale(zoom);
  translate(-minx,miny);
  translate(-pan_x,pan_y);
}

void draw_segments() {
  for(Junction ajunc:junctions) {
    //println(ajunc.id);
    //println(ajunc.outsegments);
    //ajunc.display();
    for(Junction njunc: ajunc.outsegments){
      //println(njunc.id);
      Segment seg = ODtable[ajunc.id][njunc.id];
      stroke(125);
      seg.display();
    }
  }
}

void readfiles() {
  String[] linesjunctions = loadStrings("data/junction.tsv");
  String[] linesegments = loadStrings("data/segment.tsv");
  String[] linesturning = loadStrings("data/turn.tsv");
  jn = linesjunctions.length;
  sn = linesegments.length;
  tn = linesturning.length;
  junctions = new Junction[jn];
  segments = new Segment[sn];
  ODtable = new Segment[jn][jn];
  turns = new Turn[tn];
  Xtable = new Turn[sn][jn];
  
  for (int index=0; index < jn; index++) {
    String[] pieces = split(linesjunctions[index], '\t');
    int idd = int(pieces[0]);
    float x1 = float(pieces[1]);
    float y1 = float(pieces[2]);
    junctions[idd] = new Junction(idd,x1,y1);
   }
  for (int index=0; index < sn; index++) {
    String[] pieces = split(linesegments[index], '\t');
    int sid = int(pieces[0]);
    int n1 = int(pieces[1]);
    int n2 = int(pieces[2]);
    Junction node1 = junctions[n1];
    Junction node2 = junctions[n2];
    Segment seg1 = new Segment(str(sid), 1, node1, node2);
    segments[sid] = seg1;
    ODtable[n1][n2] = seg1;
    Segment seg2 = new Segment(str(sid), 2, node2, node1);
    //segments[index+sn] = seg2;
    ODtable[n2][n1] = seg2;
  }
  
  for (int index=0; index < tn; index++) {
    String[] pieces = split(linesturning[index], '\t');
    int tid = int(pieces[0]);
    int tar = int(pieces[3]);
    float prob = float(pieces[4]);
    Junction target = junctions[tar];
    println(tid);
    if (turns[tid]==null) {
      int frm = int(pieces[1]);
      int inter = int(pieces[2]);
      Segment frm_seg = segments[frm];
      Junction intersection = junctions[inter];
      Turn aturn = new Turn(tid, frm_seg, intersection);
      turns[tid] = aturn;
      Xtable[frm][inter] = aturn;
      println(1);
    }
    Turn aturn = turns[tid];
    aturn.addtarget(target,prob);
  }
  for (Turn aturn : turns) {
    if (aturn != null) {
      aturn.probcummulate();
    }
  }
   
   
  for(Junction ajunc : junctions) {
    ajunc.finalize_neighborlist();
  }
  //Segment temp = ODtable[0][890];
  //println(temp.id);
}

void create_cars() {
  cars = new Car[junctions.length*ncar];
  int cid = 0;
  for(Junction ajunction : junctions) {
     for (int i=0;i<ncar;i++) {
       if (random(100)<=100) {
        Car acar = new Car(cid, ajunction);
        cars[cid] = acar;
        acar.display();
        //println(cid);
        cid++;
      }
      //ajunction.display();
    }
  }
  Car[] temp = Arrays.copyOf(cars, cid);
  cars = temp;
}