
import org.gicentre.utils.move.*;

String data_select="20160501";
int ln;
ZoomPan zoomer;
float minx = 295755.004;
float miny = 2762162.8811;
float maxx = 316364.0661;
float maxy = 2787932.3789;
float zoom = 0.08;//0.022328334;
float positioning_y;
float positioning_x;
float pan_x = 1000; // meter
float pan_y = 4000; // meter
long tmin=0;// = 1430438400; // unix time, s
long tmax=1440;// = 1433086405; // unix time, s
int wday_start=7;// = 5;
int t_len;
Minute[] times;
Bus[] buses;
Bus[] moving_bus;
int timenow=0;
float gmspeed = 50.0; //km/hr
int bg0;
int bg1;
int bg2;
Time showtime;
PImage logo;

void setup() {
  frameRate(24);
  size(1280, 720);
  coordinateTransform();
  zoomer = new ZoomPan(this);
  background(40);
  initialize_time();
  readfiles();
  showtime = new Time();
}

void draw() {
  showtime.updatetime();
  showtime.display(40,40);
  
  imageMode(CORNERS);
  //image(logo, 10, 620, 272.2, 714.5);
  
  zoomer.transform();
  coordinateTransform();
  //bgcolor();
  fill(bg0,bg1,bg2,80);
  //ellipse(lower_left.x, lower_left.y, 5000, 5000);
  stroke(40);
  rectMode(CORNERS);
  rect(minx-minx,-maxy-maxy,maxx+maxx,-miny+miny);//width/zoom,height/zoom);
  
  //println(times[timenow].bus_appear.length);
  for (Bus abus : times[timenow].bus_appear) {
    abus.display();
  }
  timenow++;
  if (timenow>=tmax) {
    timenow=0;
    noLoop();
  }
}