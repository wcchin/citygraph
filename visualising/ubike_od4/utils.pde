import java.util.Arrays;

void coordinateTransform() {
  translate(0,height);
  scale(zoom);
  translate(-minx,miny);
  translate(-pan_x,pan_y);
}

void initialize_time() {
  t_len = int(tmax-tmin+1);//ceil(tmax/60.0)-floor(tmin/60.0)+1;
  times = new Minute[t_len];
  for (int i=0; i<t_len;i++) {
    times[i] = new Minute(i);
  }
}

void readfiles() {
  logo = loadImage("data/logo_word_blackink.png");
  String[] linesjunctions = loadStrings("data/junction.csv");
  String[] linesegments = loadStrings("data/segment.tsv");
  String data_file="data/od_ubike_oneweek_3.csv";
  String data_file2="data/od_mrt_oneweek_5.csv";
  tmin = (long)floor(0.0/60.0);
  tmax = (long)ceil(604800.0/60.0);
  wday_start = 7;
  initialize_time();
  
  //println(data_file);
  String[] lines_OD_pair = loadStrings(data_file);
  String[] lines_MRT_flow = loadStrings(data_file2);
  String[] lines_sta_loc = loadStrings("data/youbike_station_xy4.csv");
  String[] mrt_sta_loc = loadStrings("data/mrt_station_97_2.csv");
  String[] ubikeIOs = loadStrings("data/ubike_station_IO.csv");
  //String[] lines_OD_pair = loadStrings("data/od201505_simple_2.csv");
  sn = lines_sta_loc.length-1;
  odn = lines_OD_pair.length;
  jn = linesjunctions.length;
  sgn = linesegments.length;
  sn2 = mrt_sta_loc.length-1;
  rn = lines_MRT_flow.length-1;
  un = ubikeIOs.length-1;
  
  stations = new Station[sn];
  uIOs = new UIOline[un];
  trips = new Trip[odn];
  junctions = new Junction[jn];
  segments = new Segment[sgn];
  mrts = new MRT[sn2];
  mrtflows = new MRTflow[sn2][sn2];
  rides = new Ride[rn];
  //println(sn);
  long t_st = tmin;//floor(tmin/60.0);
  
  
  for (int index=1; index < sn+1; index++) {
    String[] pieces = split(lines_sta_loc[index], ',');
    int idd = int(pieces[0]);
    int sno = int(pieces[1]);
    int xx = int(pieces[2]);
    int yy = int(pieces[3]);
    stations[idd] = new Station(idd,sno,xx,yy);
  }
  
  for (int index=1; index<un+1; index++) {
    String[] pieces = split(ubikeIOs[index], ',');
    int rid = int(pieces[0]);
    int uid = int(pieces[1]);
    int tt = int(floor((long)Double.parseDouble(pieces[2])/60.0)-t_st);
    int odg = int(pieces[3]);
    int idg = int(pieces[4]);
    uIOs[rid] = new UIOline(rid,uid,tt,odg,odg);
    times[tt].add_uIO(rid);
    //println(idd);
  }
  
  for (int index=1; index < sn2+1; index++) {
    String[] pieces = split(mrt_sta_loc[index], ',');
    int idd = int(pieces[0]);
    int sno = int(pieces[1]);
    int xx = int(pieces[2]);
    int yy = int(pieces[3]);
    mrts[idd] = new MRT(idd,sno,xx,yy);
    //println(idd);
  }
  for (int i=0; i<sn2; i++) {
    for (int j=0; j<sn2; j++){
      mrtflows[i][j] = new MRTflow(i,j);
    }
  }
  for (int index=0; index<rn; index++) {
    String[] pieces = split(lines_MRT_flow[index], ',');
    int idd = int(pieces[0]);
    int tt = int(floor((long)Double.parseDouble(pieces[1])/60.0)-t_st);
    int oo = int(pieces[2]);
    int dd = int(pieces[3]);
    int rf = int(pieces[4]);
    rides[idd] = new Ride(idd,oo,dd,tt,rf);
    times[tt].add_ride(idd);
  }
  
  for (int index=0; index < odn; index++) {
    String[] pieces = split(lines_OD_pair[index], ',');
    int idd = int(pieces[0]);
    int r0 = int(pieces[1]);
    int r1 = int(pieces[2]);
    int t0 = int(floor((long)Double.parseDouble(pieces[3])/60.0)-t_st);
    int t1 = int(floor((long)Double.parseDouble(pieces[4])/60.0)-t_st);
    //if (t0>=0 && t1<tmax) {
    trips[idd] = new Trip(idd, r0, r1, t0, t1);
    times[t0].add_trip(idd);
    //}
   }
   for (Minute m : times) {
     m.finalizing();
   }
   //println(times[0].rideupdate.length);
   /*
   for (int i=0;i<10;i++) {
     println(times[i].trip_start.length);
   }
   */
   moving_trips = new Trip[0];
   flowing_rides = new Ride[0];
   u_status = new UIOline[0];
   //add_moving(times[0].trip_start);
   
   
  for (int index=0; index < jn; index++) {
    String[] pieces = split(linesjunctions[index], ',');
    int idd = int(pieces[0]);
    float x1 = float(pieces[1]);
    float y1 = float(pieces[2]);
    junctions[idd] = new Junction(idd,x1,y1);
   }
  for (int index=0; index < sgn; index++) {
    String[] pieces = split(linesegments[index], '\t');
    int sid = int(pieces[0]);
    int n1 = int(pieces[1]);
    int n2 = int(pieces[2]);
    Junction node1 = junctions[n1];
    Junction node2 = junctions[n2];
    Segment seg1 = new Segment(str(sid), 1, node1, node2);
    segments[sid] = seg1;
    //Segment seg2 = new Segment(str(sid), 2, node2, node1);
    //segments[index+sn] = seg2;
  }
}

void set_usize(UIOline[] iolist) {
  for ( UIOline aline : iolist ) {
    aline.set_degree();
  }
}

void add_moving(Trip[] trip_list) {
  Trip[] temp = new Trip[moving_trips.length+trip_list.length];
  int cur = 0;
  for (Trip atrip:moving_trips) {
    temp[cur] = atrip;
    cur++;
  }
  for (Trip atrip:trip_list) {
    atrip.start_moving();
    temp[cur] = atrip;
    cur++;
  }
  moving_trips = temp;
}

void check_moving() {
  Trip[] temp = new Trip[moving_trips.length];
  int cur = 0;
  for (Trip atrip:moving_trips) {
    if (atrip.on==true) {
      temp[cur] = atrip;
      cur++;
    }
  }
  moving_trips = Arrays.copyOf(temp, cur);
}

void add_flowing(Ride[] ride_list) {
  Ride[] temp = new Ride[flowing_rides.length+ride_list.length];
  int cur = 0;
  for (Ride aride:flowing_rides) {
    temp[cur] = aride;
    cur++;
  }
  for (Ride aride:ride_list) {
    aride.set_riders();
    temp[cur] = aride;
    cur++;
  }
  flowing_rides = temp;
}

void check_flowing() {
  Ride[] temp = new Ride[flowing_rides.length];
  int cur = 0;
  for (Ride aride:flowing_rides) {
    if (aride.mf.check==true) {
      temp[cur] = aride;
      cur++;
    }
  }
  flowing_rides = Arrays.copyOf(temp, cur);
}

void bgcolor() {
  //println(timenow);
  int hour = floor(timenow/60.0);
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
}


void draw_segments() {
  //stroke(125, 150);
  //strokeWeight(2);
  for (Segment aseg : segments) {
    aseg.display();
  }
}