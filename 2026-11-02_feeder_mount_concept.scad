// 2026-11-02: concept view of the feeder mount as decided: each U1 feeder hangs under its
// printed insert in the top panel, outlets toward the back wall; the outlet face seals on a
// foam ring against the back wall's inner face, its collets show through the obround port,
// and two #4 x 1-3/4 screws from behind clamp it. Feeder depth (55) is a guess; the insert
// is drawn where the top opening will move to (center y ~338). Units mm, panels-file axes.

use <2026-10-30_dry_box_panels.scad>

t = 5.8; X = 640; Z = 258; Y = 385 - t;
pitch   = (X - 2 * t) / 7;
spool_d = 210; spool_w = 65;
spool_y = 210;
spool_z = t + 119.7;
feed_x  = [t + pitch, X - t - pitch];
top_in  = Z - t;                     // 252.2
back_in = Y - t;                     // 373.4
foam    = 2.1;
fd      = [58.4, 61.8, 55];          // feeder: across, along (filament), depth below the clip face
black_l = 26;                        // dark (outlet) half length
face_y  = back_in - foam;            // outlet face
port_z  = top_in - 40;
case_z  = top_in - 30;

module feeder() {   // origin: outlet face center at the clip face; inlets toward -y
    color([0.15, 0.15, 0.17]) translate([-fd[0] / 2, -black_l, -fd[2]]) cube([fd[0], black_l, fd[2]]);
    color("white") translate([-fd[0] / 2, -fd[1], -fd[2]]) cube([fd[0], fd[1] - black_l, fd[2]]);
    for (s = [-1, 1]) color("black") translate([s * 13, 0, -40]) rotate([-90, 0, 0])
        cylinder(d = 10, h = 1.5, $fn = 32);                      // collets
}

module insert() {   // drawn solid: body in the opening, flange on top
    color([0.95, 0.55, 0.1]) {
        translate([-35.8, -32.8, 0]) cube([71.6, 65.6, t]);
        translate([-44, -41, t]) cube([88, 82, 5.9]);
    }
}

for (i = [0 : 6]) {
    x = t + pitch * (i + 0.5);
    color(i < 2 || i > 4 ? "tomato" : "burlywood") translate([x, spool_y, spool_z]) rotate([0, 90, 0])
        difference() {
            cylinder(d = spool_d, h = spool_w, center = true, $fn = 72);
            cylinder(d = 55, h = spool_w + 2, center = true, $fn = 36);
        }
}

for (k = [0 : 1]) {
    fx = feed_x[k];
    translate([fx, face_y, top_in]) feeder();
    translate([fx, face_y - 33.4, top_in - 0.01]) insert();
    // foam ring around the port
    color([0.3, 0.3, 0.3]) translate([fx, face_y, port_z]) rotate([-90, 0, 0]) linear_extrude(foam)
        difference() {
            offset(r = 6) square([42, 16], center = true);
            offset(r = 8) square([26, 0.01], center = true);
        }
    for (j = [0 : 1]) {
        sx = t + pitch * (2 * k * 2.5 + j + 0.5);   // slots 0, 1 and 5, 6
        // filament: spool top to inlet
        color("red") hull() {
            translate([sx, spool_y + 20, spool_z + spool_d / 2 - 2]) sphere(d = 1.75, $fn = 8);
            translate([fx + (j - 0.5) * 26, face_y - fd[1], port_z]) sphere(d = 1.75, $fn = 8);
        }
        // PTFE tube out through the port, then down behind the box
        color([0.92, 0.96, 1.0]) {
            translate([fx + (j - 0.5) * 26, face_y, port_z]) rotate([-90, 0, 0]) cylinder(d = 4.1, h = 40, $fn = 16);
            translate([fx + (j - 0.5) * 26, face_y + 40, port_z - 60]) cylinder(d = 4.1, h = 60, $fn = 16);
        }
        // case screws from behind: heads on the outside of the back wall
        s = 2 * j - 1;
        color("silver") translate([fx + s * 46.9 / 2, Y, case_z]) rotate([90, 0, 0]) {
            translate([0, 0, -2]) cylinder(d = 5.6, h = 2, $fn = 24);   // head, outside
            cylinder(d = 2.8, h = 44, $fn = 12);                       // shaft, into the feeder
        }
    }
}

// transparent parts last (OpenCSG draws in order); top panel left off as a cutaway
color("silver") frame3d();
color([0.80, 0.88, 1.0, 0.35]) for (p = ["bottom", "back", "left", "right"]) panel3d(p);
