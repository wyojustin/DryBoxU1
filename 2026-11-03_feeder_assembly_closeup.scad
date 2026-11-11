// 2026-11-03: close-up of the left feeder assembly: insert v8 (the real STL) in the top
// panel's opening, cable slot toward the back wall; the feeder (placeholder block, depth 55
// is a guess) hangs under it with its outlet face on a 2.1 mm foam ring against the back
// wall; collets in the obround port; two #4 x 1-3/4 screws from behind. Units mm.

use <2026-10-30_dry_box_panels.scad>

t = 5.8; X = 640; Z = 258; Y = 430;
pitch  = (X - 2 * t) / 7;
fx     = t + pitch;                  // left feeder
top_in = Z - t;
back_in = Y - t;
foam   = 2.1;
hang_y = back_in - foam + 0.2 - 33;  // 338.5, as in the panels file
fd     = [58.4, 61.8, 55];
black_l = 26;
face_y = back_in - foam;
port_z = top_in - 40;
case_z = top_in - 30;

// insert, rotated so its cable slot faces the back wall
color([0.95, 0.55, 0.1]) translate([fx, hang_y, top_in]) rotate([0, 0, 180])
    import("stl/feeder_insert_qty=2.stl");

// feeder: clip face against the insert's underside, outlet face at face_y
translate([fx, face_y, top_in]) {
    color([0.15, 0.15, 0.17]) translate([-fd[0] / 2, -black_l, -fd[2]]) cube([fd[0], black_l, fd[2]]);
    color("white") translate([-fd[0] / 2, -fd[1], -fd[2]]) cube([fd[0], fd[1] - black_l, fd[2]]);
    for (s = [-1, 1]) color("black") translate([s * 13, 0, -40]) rotate([-90, 0, 0])
        cylinder(d = 10, h = 1.5, $fn = 32);
}

// ribbon up through the cable slot
color([0.6, 0.6, 0.65]) translate([fx - 9.5, back_in - 4.5, top_in - 2]) cube([19, 1, 30]);

// foam ring
color([0.3, 0.3, 0.3]) translate([fx, face_y, port_z]) rotate([-90, 0, 0]) linear_extrude(foam)
    difference() {
        offset(r = 6) square([42, 16], center = true);
        offset(r = 8) square([26, 0.01], center = true);
    }

for (j = [0 : 1]) {
    // PTFE tubes out through the port and down
    color([0.92, 0.96, 1.0]) {
        translate([fx + (j - 0.5) * 26, face_y, port_z]) rotate([-90, 0, 0]) cylinder(d = 4.1, h = 30, $fn = 16);
        translate([fx + (j - 0.5) * 26, face_y + 30, port_z - 50]) cylinder(d = 4.1, h = 50, $fn = 16);
    }
    s = 2 * j - 1;
    color("silver") translate([fx + s * 46.9 / 2, Y, case_z]) rotate([90, 0, 0]) {
        translate([0, 0, -2]) cylinder(d = 5.6, h = 2, $fn = 24);
        cylinder(d = 2.8, h = 44, $fn = 12);
    }
}

// spools in slots 0 and 1 for context
for (i = [0 : 1]) color("tomato") translate([t + pitch * (i + 0.5), 210, t + 119.7]) rotate([0, 90, 0])
    difference() { cylinder(d = 210, h = 65, center = true, $fn = 96); cylinder(d = 55, h = 67, center = true); }

// acrylic last (transparent): left wall, back wall, top panel
color([0.80, 0.88, 1.0, 0.30]) for (p = ["left", "back", "top"]) panel3d(p);
