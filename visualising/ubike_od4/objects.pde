import java.util.Arrays;

class Minute {
  int minute;
  Trip[] trip_start;
  Ride[] rideupdate;
  UIOline[] ubike_IO;
  int cur;
  int cur2;
  int cur3;
  
  Minute(int m) {
    minute = m;
    trip_start = new Trip[10];
    cur = 0;
    rideupdate = new Ride[10];
    cur2 = 0;
    ubike_IO = new UIOline[10];
    cur3 = 0;
  }
  
  void add_trip(int idd) {
    trip_start[cur] = trips[idd];
    cur++;
    int len = trip_start.length;
    if (cur >= len) {
      Trip[] temp = Arrays.copyOf(trip_start, len);
      trip_start = new Trip[len*2];
      for(int j=0;j<temp.length;j++) {
        trip_start[j] = temp[j];
      }
    }
  }
  
  void add_ride(int idd) {
    rideupdate[cur2] = rides[idd];
    cur2++;
    int len = rideupdate.length;
    if (cur2>=len) {
      Ride[] temp = Arrays.copyOf(rideupdate, len);
      rideupdate = new Ride[len*2];
      for(int j=0;j<temp.length;j++) {
        rideupdate[j] = temp[j];
      }
    }
  }
  
  void add_uIO(int rid) {
    ubike_IO[cur3] = uIOs[rid];
    cur3++;
    int len = ubike_IO.length;
    if (cur3>=len) {
      UIOline[] temp = Arrays.copyOf(ubike_IO, len);
      ubike_IO = new UIOline[len*2];
      for(int j=0;j<temp.length;j++) {
        ubike_IO[j] = temp[j];
      }
    }
  }
  
  void finalizing() {
    Trip[] temp = Arrays.copyOf(trip_start, cur);
    trip_start = temp;
    
    Ride[] temp2 = Arrays.copyOf(rideupdate, cur2);
    rideupdate = temp2;
    
    UIOline[] temp3 = Arrays.copyOf(ubike_IO, cur3);
    ubike_IO = temp3;
    //println(trip_start.length);
  }
}

// the stations
class Station {
  int ind;
  int sno;
  float xx;
  float yy;
  int indg;
  int outdg;
  int countdown;
  
  Station(int idd, int sno, float x, float y) {
    ind = idd;
    sno = sno;
    xx = x;
    yy = -y;
    indg = 0;
    outdg = 0;
    countdown = 0;
  }
  
  void display() {
    fill(0,150,0);
    ellipse(xx,yy,20+indg,20+indg);
    countdown = countdown-1;
    if (countdown==0) {
      indg = 0;
      outdg = 0;
    }
  }
  
  void setindegree(int ii) {
    indg = ii;
    countdown = 60;
  }  
  void setoutdegree(int oo) {
    outdg = oo;
    countdown = 60;
  }
}

class UIOline {
  int rid;
  int uid;
  Station sta;
  int time;
  int indegree;
  int outdegree;
  
  UIOline(int rid,int uid,int time,int outdg,int indg) {
    rid = rid;
    uid = uid;
    sta = stations[uid];
    indegree = indg;
    outdegree = outdg;
  }
  
  void set_degree() {
    sta.setindegree(indegree);
  }
}

class Trip {
  int idd;
  Station from;
  Station to;
  int t0; // minute
  int t1; // minute
  float dist;
  int minute_used;
  int minute_left;
  float px;
  float py;
  float dx;
  float dy;
  float speed;
  float direction; // in radian form
  boolean on;
  
  Trip(int idd, int s0, int s1, int t0a, int t1a) {
    on = false;
    idd = idd;
    from = stations[s0];
    to = stations[s1];
    t0 = t0a;
    t1 = t1a;
    dist = sqrt(pow((from.xx-to.xx),2)+pow((from.yy-to.yy),2));
    minute_used = t1 - t0;
    minute_left = minute_used+1;
    speed = dist/minute_used;
    px = from.xx;
    py = from.yy;
    PVector temp = new PVector(to.xx-from.xx, to.yy-from.yy);
    direction = temp.heading();
    dx = cos(direction)*speed;
    dy = sin(direction)*speed;
  }
  
  void move() {
    px=px+dx;
    py=py+dy;
    minute_left=minute_left-1;
    check_off();
  }
  
  void check_off() {
    if (minute_left<=0) {
      on=false;
    }
  }
  
  void display() {
    if (on) {
      fill(137,254,5,150);
      ellipse(px,py,20,20);
    }
  }
  
  void start_moving() {
    on = true;
  }
  void stop_moving() {
    on = false;
  }
}


class MRT {
  int ind;
  int sid;
  float xx;
  float yy;
  
  MRT(int idd, int sid, float x, float y) {
    ind = idd;
    sid = sid;
    xx = x;
    yy = -y;
  }
  
  void display() {
    fill(130,202,252,150);
    rectMode(CENTER);
    rect(xx,yy,70,70);
  }
}

class MRTflow {
  //int idd;
  MRT origin;
  MRT destin;
  int ridership;
  int oid;
  int did;
  float x0;
  float y0;
  float x1;
  float y1;
  int countdown;
  boolean check;
  
  MRTflow(int o, int d) {
    //idd = idd;
    oid = o;
    did = d;
    origin = mrts[o];
    destin = mrts[d];
    x0 = origin.xx;
    y0 = origin.yy;
    x1 = destin.xx;
    y1 = destin.yy;
    ridership = 0;
  }
  
  void set_ridership(int f) {
    ridership = f;
    countdown = 60;
    check = true;
  }
  
  void display() {
    if (check) {
      stroke(20,20,250,10);
      strokeWeight(5);
      line(x0,y0,x1,y1);
      countdown = countdown - 1;
      if (countdown==0) {
        check = false;
      }
    }
  }
}

class Ride {
  int idd;
  MRTflow mf;
  int tt;
  int ridership;
  float minute_left;
  float px;
  float py;
  float dx;
  float dy;
  boolean on;
  
  Ride(int i, int oo, int dd, int t, int r) {
    idd = i;
    mf = mrtflows[oo][dd];
    tt = t;
    ridership = r;
    on = false;
    
    float dist = sqrt(pow((mf.x0-mf.x1),2)+pow((mf.y0-mf.y1),2));
    float minute_used = 60.0;
    minute_left = minute_used+1.0;
    float speed = dist/minute_used;
    px = mf.x0;
    py = mf.y0;
    PVector temp = new PVector(mf.x1-mf.x0, mf.y1-mf.y0);
    float direction = temp.heading();
    dx = cos(direction)*speed;
    dy = sin(direction)*speed;
  }
  
  void set_riders() {
    startmove();
    mf.set_ridership(ridership);
  }
  
  void display() {
    if (on) {
      fill(130,202,252,150);
      ellipse(px,py,20+ridership,20+ridership);
      move();
    }
  }
  
  void startmove() {
    on = true;
  }
  
  void check_off() {
    if (minute_left<=0) {
      on=false;
    }
  }
  
  void move() {
    px=px+dx;
    py=py+dy;
    minute_left=minute_left-1;
    check_off();
  }
}


class Time {
  int year;
  int month;
  int day;
  int hour;
  int minute;
  int dayinweek;
  
  Time() {
    //int y = int(data_select.substring(0,4));
    //int m = int(data_select.substring(4));
    //int d = 0;
    dayinweek = wday_start;
    //year=y;
    //month=m;
    //day=d;
    day = 1;
    hour=floor(timenow/60.0);
    minute=timenow%60;
    //println(day);
  }
  void updatetime() {
    int net_minute = timenow-(day-1)*1440;
    hour=floor(net_minute/60.0);
    if (hour==24) {
      day++;
      dayinweek++;
      hour=0;
    }
    int temp = floor(hour/6.0);
    int check = temp%4;
    if (check==1) {
      bg0 = 30;
      bg1 = 50;
      bg2 = 5;
    } else {
      if (check==2) {
        bg0 = 80;
        bg1 = 10;
        bg2 = 5;
      } else {
        if (check==3) {
          bg0 = 0;
          bg1 = 0;
          bg2 = 80;
        } else {
          bg0 = 5;
          bg1 = 5;
          bg2 = 5;
        }
      }
    }
    if (dayinweek>7) {
      dayinweek = 1;
    }
    minute=net_minute%60;
  }
  void display(int txx, int tyy) { 
    String mm1 = str(month);
    if (month<10) {
      mm1 = "0".concat(str(month));
    }
    String dd1 = str(day);
    if (day<10) {
      dd1 = "0".concat(str(day));
    }
    String hh = str(hour);
    if (hour<10) {
      hh = "0".concat(str(hour));
    }
    String mm = str(minute);
    if (minute<10) {
      mm = "0".concat(str(minute));
    }
    String ww;
    switch(dayinweek) {
      case 1:
        ww = "Monday";
        break; 
      case 2:
        ww = "Tuesday";
        break; 
      case 3:
        ww = "Wednesday";
        break; 
      case 4:
        ww = "Thursday";
        break; 
      case 5:
        ww = "Friday";
        break; 
      case 6:
        ww = "Saturday";
        break; 
      case 7:
        ww = "Sunday";
        break; 
      default:
        ww = "unknown";
        break;
    }
    //String tt = str(year).concat("/").concat(mm1).concat("/").concat(dd1).concat(" - ").concat(hh).concat(":").concat(mm).concat(" - ").concat(ww);
    String tt = ("Passenger flow in Taipei City \n").concat(hh).concat(":").concat(mm).concat(" - ").concat(ww);
    fill(200, 200, 200);
    textSize(32);
    text(tt, txx, tyy);
  }
}



// the junctions of streets
class Junction {
  int id;
  //PVector jpt;
  float xx;
  float yy;
  
  Junction(int idd, float x, float y) {
    id = idd;
    //jpt = new PVector(x, -y);
    xx = x;//(x - minx)*zoom-positioning_x - width*(1-pan_x);
    //float ya1 = (y - miny)*zoom-positioning_y;
    yy = -y;//(y - miny)*zoom-positioning_y - height*(1-pan_y);// -(ya1-height*pan_y);
  }
  
  void display() {
    fill(150);
    //point(xx,yy);
    ellipse(xx,yy,50,50);
    //line(xx1, yy1, xx2, yy2);
  }
}

// the segments between junctions
class Segment {
  String id;
  int dirtype;
  Junction node1;
  Junction node2;
  /*
  float direction; // in radian form
  float distance;
  float speed = gmspeed*1000/3600; // m/s
  float dx;
  float dy;
  int carcount;
  */
  int rr = 10;
  int gg = 10;
  int bb = 10;
  int aa = 90;
  
  Segment(String idd, int dt, Junction n1, Junction n2) {
    id = idd;
    dirtype = dt;
    node1 = n1;
    node2 = n2;
    //node1.addneighbor(node2);
    //PVector temp = new PVector(node2.xx-node1.xx, node2.yy-node1.yy);
    //direction = temp.heading();
    //distance = sqrt(pow((node2.xx-node1.xx),2)+pow((node2.yy-node1.yy),2));
    //dx = cos(direction);//*distance/needtime;//*speed*1;
    //dy = sin(direction);//*distance/needtime;//*speed*1;
    //carcount = 0;
  }
  
  void display() {
    //stroke(150);
    float xx1 = node1.xx;
    float yy1 = node1.yy;
    float xx2 = node2.xx;
    float yy2 = node2.yy;
    //float cc = float(carcount)/distance*10000.0;
    rr = 0;
    gg = 250;
    bb = 0;
    aa = 50;
    if (draw_streets) {
      //stroke(rr,gg,bb,aa);
      strokeWeight(12);
      line(xx1, yy1, xx2, yy2);
    }
  }
}