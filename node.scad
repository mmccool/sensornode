// Sensor Node
// Mounting plates for Arduino/Edison to support USB cameras, Grove sensors, 4D display
// all units in mm

tol = 0.1;       // general tolerance for fitting parts
eps = 0.00001;   // epsilon, used to resolve CGS issues
cut_width = 0.1; // width of laser cut
sm = 30;        // general smoothness factor
plate_t = 5;       // plate thickness for laser-cut parts
plate_t_tol = 0.25; // plate thickness tolerance

// base plate dimensions
base_x = 150;
base_y = 150;
base_r = 10;
base_rr = 5;
base_sm = 3*sm;
// base_bolt_r = 3.2/2;
base_bolt_r = 4.2/2;
base_bolt_sm = sm;
base_a = 45;

spacer_r = 1.7*base_bolt_r;
spacer_h = 50;   // spacer height

// Edison/Arduino bolt hole positions
e_x = 116;
e_y = 65.7;
e_yo = 10;
e_bolt_r = 3.2/2;
e_bolt_origin = [100.1,53.9];
e_bolt_pos = [
  [0,0],
  [0,53.9]
];
e_bolt_sm = sm;
e_offset = [base_x/2 - 116/2,e_yo];

// Arduino bolt hole positions
a_bolt_r = 3.2/2;
a_bolt_pos = [
  e_bolt_origin-[0,0],
  e_bolt_origin-[51.9,4.7],
  e_bolt_origin-[51.9,4.7+27.9],
  e_bolt_origin-[1.1,4.7+27.9+15.2], // correct Arduino
  e_bolt_origin-[0.0,4.7+27.9+15.2]  // Edison (does not match drawing, but!)
];
a_bolt_sm = sm;
a_offset = [base_x/2 - 116/2,e_yo];

// UP Board/Rasp Pi bolt hole positions
// bolts to mount plates to PCB
u_bolt_r = 2.7/2;
u_bolt_pos = [
  [3.5,3.5],
  [3.5,52.5],
  [61.5,52.5],
  [61.5,3.5]
];
u_bolt_sm = sm;
u_offset = [base_x/2 - 116/2+50,e_yo];

// DF Robot 25W 5V power convertor (needed for UP/RaspPi)
p_bolt_r = 3.2/2;
p_bolt_pos = [
  [3.5,3.5],
  [3.5,50.6-3.5],
  [46.5-3.5,3.5],
  [46.5-3.5,50.6-3.5]
];
p_bolt_sm = sm;
p_offset = [base_x/2 - 116/2-10,e_yo+5];

// 4D display bolt hole positions
d_bolt_r = 3.2/2;
d_x = 52;
d_y = 36;
d_xo = 3;
d_yo = 6.2;
d_bolt_pos = [
  [0,0],
  [46,0],
  [0,26],
  [46,26]
];
d_bolt_sm = sm;
d_offset_yy = 10;
d_offset = [3*base_x/4-d_x/2,3*base_y/4-d_y/2+d_offset_yy];

// Edison/Arduino PCB size
pcb_x = 85; // length
pcb_y = 56; // width

module spacer() {
  cylinder(r=spacer_r,h=spacer_h,$fn=6);
}

module spacers(
  pos = base_pos
) {
  for (p = pos)
    translate(p)
      spacer();
}

module bolt_holes(
  pos = e_bolt_pos,
  r = e_bolt_r,
  sm = e_bolt_sm
) {
  for (p = pos)
    translate(p)
      circle(r=r,$fn=sm);
}

notch_r = 0.5;
notch_w = plate_t + plate_t_tol;
notch_d = 2;
notch_sm = sm;
module notch() {
  translate([-notch_w/2,-notch_d])
    square([notch_w,2*notch_d]);
  translate([notch_w/2,notch_d])
    circle(r=notch_r,$fn=notch_sm);
  translate([-notch_w/2,notch_d])
    circle(r=notch_r,$fn=notch_sm);
  translate([notch_w/2,-notch_d])
    circle(r=notch_r,$fn=notch_sm);
  translate([-notch_w/2,-notch_d])
    circle(r=notch_r,$fn=notch_sm);
}

base_pos = [
  [0,0],
  [base_x,0],
  [0,base_y],
  [base_x,base_y]
];

module base(
  x = base_x,
  y = base_y,
  pos = base_pos,
  r = base_r,
  rr = base_rr,
  sm = base_sm
) {
  difference() {
    union() {
      // corner bulges (act as feet in both orientations)
      hull() {
        translate(pos[0]) circle(r=r,$fn=sm);
        translate(pos[3]) circle(r=r,$fn=sm);
      }
      hull() {
        translate(pos[1]) circle(r=r,$fn=sm);
        translate(pos[2]) circle(r=r,$fn=sm);

      }
      // center panel
      translate([-r*sin(base_a),-r*sin(base_a)])
        square([base_x+2*r*sin(base_a),base_y+2*r*sin(base_a)]);
    }
    // smooth edge inset, left
    hull() {
      translate([-(r+rr)*sin(base_a),(r+rr)*cos(base_a)]) 
        circle(r=rr,$fn=sm);
      translate([-(r+rr)*sin(base_a),y-(r+rr)*cos(base_a)])
        circle(r=rr,$fn=sm);
      translate([-(r+rr)*sin(base_a)-r,(r+rr)*cos(base_a)]) 
        circle(r=rr,$fn=sm);
      translate([-(r+rr)*sin(base_a)-r,y-(r+rr)*cos(base_a)])
        circle(r=rr,$fn=sm);
    }
    // smooth edge inset, right
    hull() {
      translate([x+(r+rr)*sin(base_a),(r+rr)*cos(base_a)]) 
        circle(r=rr,$fn=sm);
      translate([x+(r+rr)*sin(base_a),y-(r+rr)*cos(base_a)])
        circle(r=rr,$fn=sm);
      translate([x+(r+rr)*sin(base_a)+r,(r+rr)*cos(base_a)]) 
        circle(r=rr,$fn=sm);
      translate([x+(r+rr)*sin(base_a)+r,y-(r+rr)*cos(base_a)])
        circle(r=rr,$fn=sm);
    }
    // smooth edge inset, bottom
    hull() {
      translate([(r+rr)*cos(base_a),-(r+rr)*sin(base_a)]) 
        circle(r=rr,$fn=sm);
      translate([x-(r+rr)*cos(base_a),-(r+rr)*sin(base_a),])
        circle(r=rr,$fn=sm);
      translate([(r+rr)*cos(base_a),-(r+rr)*sin(base_a)-r]) 
        circle(r=rr,$fn=sm);
      translate([x-(r+rr)*cos(base_a),-(r+rr)*sin(base_a)-r])
        circle(r=rr,$fn=sm);
    }
    // smooth edge inset, top
    hull() {
      translate([(r+rr)*cos(base_a),y+(r+rr)*sin(base_a)]) 
        circle(r=rr,$fn=sm);
      translate([x-(r+rr)*cos(base_a),y+(r+rr)*sin(base_a)])
        circle(r=rr,$fn=sm);
      translate([(r+rr)*cos(base_a),y+(r+rr)*sin(base_a)+r]) 
        circle(r=rr,$fn=sm);
      translate([x-(r+rr)*cos(base_a),y+(r+rr)*sin(base_a)+r])
        circle(r=rr,$fn=sm);
    }
    // notches (for stacking), bottom
    translate([base_x/2-35,-(r+rr)*sin(base_a)+rr]) {
      translate([-spacer_h/2-notch_w/2,0*notch_d]) notch();
      translate([ spacer_h/2+notch_w/2,0*notch_d]) notch();
    }
    translate([base_x/2,-(r+rr)*sin(base_a)+rr]) {
      translate([-spacer_h/2-notch_w/2,0*notch_d]) notch();
      translate([ spacer_h/2+notch_w/2,0*notch_d]) notch();
    }
    translate([base_x/2+35,-(r+rr)*sin(base_a)+rr]) {
      translate([-spacer_h/2-notch_w/2,0*notch_d]) notch();
      translate([ spacer_h/2+notch_w/2,0*notch_d]) notch();
    }
    // notches (for stacking), top
    translate([base_x/2-35,y+(r+rr)*sin(base_a)-rr]) {
      translate([-spacer_h/2-notch_w/2,0*notch_d]) notch();
      translate([ spacer_h/2+notch_w/2,0*notch_d]) notch();
    }
    translate([base_x/2,y+(r+rr)*sin(base_a)-rr]) {
      translate([-spacer_h/2-notch_w/2,0*notch_d]) notch();
      translate([ spacer_h/2+notch_w/2,0*notch_d]) notch();
    }
    translate([base_x/2+35,y+(r+rr)*sin(base_a)-rr]) {
      translate([-spacer_h/2-notch_w/2,0*notch_d]) notch();
      translate([ spacer_h/2+notch_w/2,0*notch_d]) notch();
    }
  }
}

// adjustable foot (optional)
foot_d = 2*base_r;
foot_rr = 2.0/2; // locking holes
foot_n = 18; // number of locking holes
module foot() {
  difference() {
    hull() {
      circle(r=base_r,$fn=base_sm);
      translate([0,foot_d]) circle(r=base_rr,$fn=base_sm);
    }
    circle(r=base_bolt_r,$fn=base_bolt_sm);
    for (i=[0:2:foot_n-1])
      rotate(i*360/foot_n)
        translate([0.55*base_r,0])
          circle(r=foot_rr,$fn=base_bolt_sm);
    for (i=[1:2:foot_n-1])
      rotate(i*360/foot_n)
        translate([0.8*base_r,0])
          circle(r=foot_rr,$fn=base_bolt_sm);
  }
}

grove_r = 2.7/2;
grove_s = 10;
grove_sm = sm;
module grove(n=10,m=10) {
  for (i=[0:n])
    for (j=[0:m])
      translate([i*grove_s,j*grove_s])
        circle(r=grove_r,$fn=grove_sm);
}
grove_R = 4.5/2;
module grove_slot(n=10,m=10,dn=1,dm=0) {
  hull() {
    translate([n*grove_s,m*grove_s])
      circle(r=grove_R,$fn=grove_sm);
    translate([(n+dn)*grove_s,(m+dm)*grove_s])
      circle(r=grove_R,$fn=grove_sm);
  }
}

camera_x = 28;
camera_y = 28;
camera_hx = 18;
camera_hy = 18;
camera_R = 4.5/2;
camera_bolt_r = 2.7/2;
camera_cr = 1;
camera_offset = [base_x/4,3*base_y/4+10];
camera_sm = sm;
module camera() {
  // center square cutout
  hull() {
    translate([-camera_hx/2,-camera_hy/2])
      circle(r=camera_cr,$fn=camera_sm);
    translate([-camera_hx/2,camera_hy/2])
      circle(r=camera_cr,$fn=camera_sm);
    translate([camera_hx/2,-camera_hy/2])
      circle(r=camera_cr,$fn=camera_sm);
    translate([camera_hx/2,camera_hy/2])
      circle(r=camera_cr,$fn=camera_sm);
  }
  // side notches
  hull() {
    translate([camera_hx/2+camera_R,0])
      circle(r=camera_R,$fn=2*camera_sm);
    translate([-camera_hx/2-camera_R,0])
      circle(r=camera_R,$fn=2*camera_sm);
  }
  // bolt holes
  translate([-camera_x/2,-camera_y/2])
    circle(r=camera_bolt_r,$fn=camera_sm);
  translate([-camera_x/2,camera_y/2])
    circle(r=camera_bolt_r,$fn=camera_sm);
  translate([camera_x/2,-camera_y/2])
    circle(r=camera_bolt_r,$fn=camera_sm);
  translate([camera_x/2,camera_y/2])
    circle(r=camera_bolt_r,$fn=camera_sm);
}

// base_bolt_n = 1;
base_bolt_n = 0;
module plate(os = base_bolt_r) {
  difference() {
    base();
    for (ox = [-base_bolt_n:1:base_bolt_n]) {
      translate([os*ox,0])
        bolt_holes(pos=base_pos,r=base_bolt_r,sm=base_bolt_sm);
    }
    for (oy = [-base_bolt_n:1:base_bolt_n]) {
      if (oy != 0) {
        translate([0,os*oy])
          bolt_holes(pos=base_pos,r=base_bolt_r,sm=base_bolt_sm);
      }
    }
  }
}

foot_ph = 1;
module front_plate() {
  difference() {
    plate(os=3.5*base_bolt_r);
    // Grove mounting points
    translate([grove_s,grove_s])
      grove(n=floor(base_x/grove_s)-2,m=floor((base_y/2)/grove_s)+1);
    // Grove wiring slots
    grove_slot(n=1,m=1,dn=1,dm=0);
    grove_slot(n=4,m=1,dn=1,dm=0);
    grove_slot(n=7,m=1,dn=1,dm=0);
    grove_slot(n=10,m=1,dn=1,dm=0);
    grove_slot(n=13,m=1,dn=1,dm=0);
    // 4D display mounting points
    translate([d_offset[0]+d_xo,d_offset[1]+d_yo])
      bolt_holes(pos=d_bolt_pos,r=d_bolt_r,sm=d_bolt_sm);
    // camera mount
    translate(camera_offset)
      camera();
    // foot anchor holes (allow for vernier adjustments)
    for (i=[0:2:foot_n-1-2])
      rotate((i-foot_ph)*360/(foot_n-2))
        translate([0.55*base_r,0])
          circle(r=foot_rr,$fn=base_bolt_sm);
    for (i=[1:2:foot_n-1-2])
      rotate((i-foot_ph)*360/(foot_n-2))
        translate([0.8*base_r,0])
          circle(r=foot_rr,$fn=base_bolt_sm);
    translate([base_x,0]) {
      for (i=[0:2:foot_n-1-2])
        rotate((i+foot_ph)*360/(foot_n-2))
          translate([0.55*base_r,0])
            circle(r=foot_rr,$fn=base_bolt_sm);
      for (i=[1:2:foot_n-1-2])
        rotate((i+foot_ph)*360/(foot_n-2))
          translate([0.8*base_r,0])
            circle(r=foot_rr,$fn=base_bolt_sm);
    }
  }
}

module back_plate() {
  difference() {
    plate(os=3*base_bolt_r);
    // Edison/Arduino
    translate(a_offset)
      bolt_holes(pos=a_bolt_pos,r=a_bolt_r,sm=a_bolt_sm);
    translate(e_offset)
      bolt_holes(pos=e_bolt_pos,r=e_bolt_r,sm=e_bolt_sm);
    // UP Board/Rasp Pi
    translate(u_offset)
      bolt_holes(pos=u_bolt_pos,r=u_bolt_r,sm=u_bolt_sm);
    // DF Robot Power
    translate(p_offset)
      bolt_holes(pos=p_bolt_pos,r=p_bolt_r,sm=p_bolt_sm);
    // Grove mounting points
    translate([grove_s,2*e_yo+e_y])
      grove(n=floor(base_x/grove_s)-2,m=floor((base_y-2*e_yo-e_y)/grove_s)-1);
    // Grove wiring slots
    translate([0,e_yo+e_y]) {
      grove_slot(n=1,m=1,dn=1,dm=0);
      grove_slot(n=4,m=1,dn=1,dm=0);
      grove_slot(n=7,m=1,dn=1,dm=0);
      grove_slot(n=10,m=1,dn=1,dm=0);
      grove_slot(n=13,m=1,dn=1,dm=0);
    }
  }
}

module assembly() {
  color([0.75,0.75,0.75,0.5])
    translate([0,0,-spacer_h-plate_t])
      linear_extrude(plate_t)
        back_plate();
  color([0.5,0.5,0.55,1]) 
    translate([0,0,-spacer_h])
      spacers();
  color([0.75,0.75,0.75,0.5]) 
    linear_extrude(plate_t)
      front_plate();
  color([0.75,0.75,0.75,0.5]) 
    translate([0,0,plate_t+tol])
      linear_extrude(plate_t)
        foot();
  color([0.75,0.75,0.75,0.5]) 
    translate([base_x,0,plate_t+tol])
      linear_extrude(plate_t)
        foot();
}

// Components
//base();

// Cut
//front_plate();
//back_plate();
//foot();

// Visualize
assembly();

