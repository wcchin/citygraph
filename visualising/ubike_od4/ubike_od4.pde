
import org.gicentre.utils.move.*;

//String data_select="201501";
int odn;
int sn;
int sn2;
int rn;
int sgn;
int jn;
int un;
Junction[] junctions;
Segment[] segments;
Station[] stations;
UIOline[] uIOs;
MRT[] mrts;
Ride[] rides;
Trip[] trips;
MRTflow[][] mrtflows;
UIOline[] u_status;
ZoomPan zoomer;
float minx = 295800.004;
float miny = 2762162.8811;
float maxx = 316364.0661;
float maxy = 2787982.3789;
float zoom = 0.1;//0.022328334;
float positioning_y;
float positioning_x;
float pan_x = 2000; // meter
float pan_y = 4000; // meter
long tmin;// = 1430438400; // unix time, s
long tmax;// = 1433086405; // unix time, s
int wday_start;
int t_len;
Minute[] times;
int timenow=0;
float gmspeed = 50.0; //km/hr
Trip[] moving_trips;
Ride[] flowing_rides;
int bg0;
int bg1;
int bg2;
Time showtime;
boolean draw_streets=true;
PImage logo;

void setup() {
  frameRate(24);
  size(1366, 720);
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
  fill(137,254,5,150);
  ellipse(1240,600, 20, 20);
  fill(137,254,5,150);
  textSize(24); 
  text("Youbike", 1253, 610);

  fill(130,202,252,150);
  rectMode(CENTER);
  rect(1240,640,20,20);
  fill(130,202,252,150);
  textSize(24); 
  text("MRT", 1253, 650);
  //text("Lab for Geospatial Computational Science, NTU Geography", 40, 680);
  
  imageMode(CORNERS);
  image(logo, 10, 620);
  
  zoomer.transform();
  coordinateTransform();
  //bgcolor();
  //fill(bg0,bg1,bg2,40);
  fill(0,0,0,40);
  //ellipse(lower_left.x, lower_left.y, 5000, 5000);
  stroke(40);
  rectMode(CORNERS);
  rect(minx-minx,-maxy-maxy,maxx+maxx,-miny+miny);//width/zoom,height/zoom);
  
  strokeWeight(5);
  stroke(180,30);
  draw_segments();
  strokeWeight(1);
  stroke(180,5);
  
  //println(timenow);
  
  add_moving(times[timenow].trip_start);
  for(Trip atrip : moving_trips) {
    atrip.move();
    atrip.display();
  }
  check_moving();
  
  
  add_flowing(times[timenow].rideupdate);
  for(Ride aride : flowing_rides) {
    //println(i);
    aride.display();
  }
  check_flowing();
  
  u_status = times[timenow].ubike_IO;
  set_usize(u_status);
  
  for(Station sta : stations) {
    sta.display();
  }
  
  for(MRT msta : mrts) {
    msta.display();
  }
  
  timenow++;
}