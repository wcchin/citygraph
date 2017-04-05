import java.util.Arrays;

class Minute {
  int minute;
  Bus[] bus_appear;
  int cur;
  
  Minute(int m) {
    minute = m;
    bus_appear = new Bus[20];
    cur = 0;
  }
  
  void add_trip(int idd) {
    bus_appear[cur] = buses[idd];
    cur++;
    int len = bus_appear.length;
    if (cur >= len) {
      Bus[] temp = Arrays.copyOf(bus_appear, len);
      bus_appear = new Bus[len*2];
      for(int j=0;j<temp.length;j++) {
        bus_appear[j] = temp[j];
      }
    }
  }
  
  void finalizing() {
    Bus[] temp = Arrays.copyOf(bus_appear, cur);
    bus_appear = temp;
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
    int y = int(data_select.substring(0,4));
    int m = int(data_select.substring(4,6));
    int d = int(data_select.substring(6));
    dayinweek = wday_start;
    year=y;
    month=m;
    day=d;
    hour=floor(timenow/60.0);
    minute=timenow%60;
  }
  void updatetime() {
    int net_minute = timenow-(day-1)*1400;
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
    String tt = str(year).concat("/").concat(str(month)).concat("/").concat(str(day)).concat(" - ").concat(hh).concat(":").concat(mm).concat(" - ").concat(ww);
    fill(200, 200, 200);
    textSize(32);
    text(tt, txx, tyy);
  }
}

class Bus {
  int idd;
  int time;
  float xx;
  float yy;
  String busid;
  String routeid;
  
  Bus(int id, String route, String plate, int tloc, float xloc, float yloc) {
    idd = id;
    routeid = route;
    busid = plate;
    time = tloc;
    xx = xloc;
    yy = yloc;
  }
  void display() {
    fill(150);
    ellipse(xx,yy,50,50);
  }
  
}