//import java.util.Arrays;
import org.gicentre.utils.move.*;


int sn;
int jn;
int tn;
Junction[] junctions;
Segment[] segments;
Segment[][] ODtable;
Turn[] turns;
Turn[][] Xtable;
Car[] cars;
float minx = 295755.004;
float miny = 2762162.8811;
float maxx = 316364.0661;
float maxy = 2787932.3789;
float zoom = 0.2;//0.022328334;
float positioning_y;
float positioning_x;
float pan_x = 4000; // meter
float pan_y = 6000; // meter
PVector lower_left = new PVector(minx+pan_x,-miny-pan_y);
float gmspeed = 40.0; //km/hr
int ncar = 2;
ZoomPan zoomer;
boolean random_turn = false;
boolean draw_streets = false;
boolean draw_cars = true;


void setup() {
  frameRate(36);
  size(1920, 1000);
  coordinateTransform();
  zoomer = new ZoomPan(this);
  //positioning_y = (maxy-miny)/2*zoom-height/2;
  //positioning_x = (maxx-minx)/2*zoom-width/2;
  background(40);
  //stroke(150);
  readfiles();
  create_cars();
  //draw_segments();
  //testcar = new Car(9999,junctions[5916]);
}

void draw() {
  zoomer.transform();
  coordinateTransform();
  fill(20,30);
  //ellipse(lower_left.x, lower_left.y, 5000, 5000);
  stroke(40);
  rectMode(CORNERS);
  rect(minx-minx,-maxy-maxy,maxx+maxx,-miny+miny);//width/zoom,height/zoom);
  //draw_segments();
  //testcar.drive();
  //testcar.display();
  fill(120,180);
  for(Car acar : cars) {
    //println(acar.id);
    acar.drive();
  }
  
  draw_segments();
  
  if (draw_cars) {
    for(Car acar : cars) {
      acar.display();
    }
  }
  
}