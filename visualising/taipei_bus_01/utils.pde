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
  
  logo = loadImage("data/logo_small.JPG");
  
  //println(data_file);
  //String[] lines_locations = loadStrings("data/simple_route_11833.csv");
  String[] lines_locations = loadStrings("data/simple_routes_all.csv");
  ln = lines_locations.length;
  
  buses = new Bus[ln];
  
  for (int index=1; index < ln; index++) {
    String[] pieces = split(lines_locations[index], ',');
    int idd = int(pieces[0]);
    String rid = pieces[1];
    String bid = pieces[2];
    int tloc = int(pieces[3]);
    float xx = float(pieces[4]);
    float yy = float(pieces[5]);
    buses[idd] = new Bus(idd,rid,bid,tloc,xx,-yy);
    times[tloc].add_trip(idd);
  }

   for (Minute m : times) {
     m.finalizing();
   }
}