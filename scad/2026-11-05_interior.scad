// 2026-11-05: acrylic inside the box: tunnel (floor, 2 walls, perforated deck), desiccant tray, and
// the 2 spool holders' plates and strips. One source for these sizes: the assembly draws them
// and its cut list prints them from here. Butt joints, solvent cement.
// part = "sheet" (everything nested on spare sheet 1, 24 x 36 in; cut with the film off)
//      | "gasket" (2 feeder gaskets, for the EVA sheet) | "cord_plug" (spare; a PG13.5 gland is the plan).
// Units mm. Pieces lie flat, corner at the origin.

use <2026-10-30_dry_box_panels.scad>
use <2026-11-04_spool_holder.scad>

part = "sheet";

sd = shell_dims();
X = sd[0]; Y = sd[1]; Z = sd[2]; t = sd[3]; ext = sd[4];
back_in = Y - t;
dr      = [190, 400, 50]; dr_air = 25;    // tray x, y, z; air gap above it
tun_in  = dr[0] + 4;                      // between the tunnel walls
tun_w   = tun_in + 2 * t;
tun_l   = back_in - ext - 0.5;            // floor and walls: back wall to the front frame member
deck_l  = back_in - 1;                    // deck: runs on over the frame member
wall_h  = dr[2] + dr_air;
vent_d  = 16; vent_p = 32;
deck_d  = 12; deck_p = 24;
pull    = [40, 16];                       // finger notch in the tray's front end

function int_dr()  = dr;
function int_air() = dr_air;
function int_tun() = [tun_in, tun_w, tun_l, deck_l, wall_h];

module deck2d() difference() {            // holes stay clear of the walls below
    square([tun_w, deck_l]);
    for (ix = [-3 : 3], iy = [0 : 15]) translate([tun_w / 2 + ix * deck_p, 29 + iy * deck_p]) circle(d = hole(deck_d), $fn = 32);
}
module floor2d() square([tun_w, tun_l]);
module wall2d() difference() {            // x along the box's depth, y up; vents in the air gap
    square([tun_l, wall_h]);
    for (y = [21.5 : vent_p : tun_l - 10]) translate([y, wall_h - dr_air / 2]) circle(d = hole(vent_d), $fn = 48);
}
module tray_bottom2d() square([dr[0], dr[1]]);
module tray_side2d() square([dr[1], dr[2] - t]);
module tray_end2d(notch = false) difference() {
    square([dr[0] - 2 * t, dr[2] - t]);
    if (notch) translate([(dr[0] - 2 * t) / 2, dr[2] - t]) hull() for (s = [-1, 1])
        translate([s * (pull[0] / 2 - pull[1]), 0]) circle(r = pull[1], $fn = 48);
}

// feeder gasket: EVA, on the port (seen from inside the box); case screws at +10 above the port
module gasket2d() {
    pd = 26; cd = 46.9;                    // collet and case screw spacing (panels file)
    difference() {
        offset(r = 6, $fn = 48) square([pd + 16, 16], center = true);
        hull() for (s = [-1, 1]) translate([s * pd / 2, 0]) circle(d = 16.4, $fn = 48);
        for (s = [-1, 1]) translate([s * cd / 2, 10]) circle(d = 3.2, $fn = 32);
    }
}

// cord hole plug: pushes in from outside the back panel, 3 crush ribs in the hole, flange on an
// EVA ring. Prints flange down. A heater later gets a plug with its own cord hole.
ch = cord_hole();
module cord_plug() {
    cylinder(d = ch[0] + 10, h = 2, $fn = 64);
    translate([0, 0, 2]) {
        cylinder(d = ch[0] - 0.4, h = t, $fn = 64);
        for (a = [0, 120, 240]) rotate(a) translate([ch[0] / 2 - 1, -0.6, 0]) cube([1.2, 1.2, t]);
    }
}
module cord_ring2d() difference() { circle(d = ch[0] + 10, $fn = 64); circle(d = ch[0] + 0.4, $fn = 64); }

// nest, in 3 columns on a 610 x 914 sheet
m = 5; g = 6;
c2 = m + tun_w + g; c3 = c2 + dr[0] + g;
module cut() offset(delta = 0.125) children();
module sheet() {
    translate([m, m]) cut() deck2d();
    translate([m, m + deck_l + g]) cut() floor2d();
    for (i = [0 : 2]) translate([m, m + deck_l + tun_l + 2 * g + i * 18]) cut() strip2d();
    translate([c2, m]) cut() tray_bottom2d();
    for (i = [0 : 1]) translate([c2 + i * (wall_h + g) + wall_h, m + dr[1] + g]) rotate(90) cut() wall2d();
    translate([c2, m + dr[1] + tun_l + 2 * g]) cut() tray_end2d(true);
    translate([c2, m + dr[1] + tun_l + 2 * g + 50]) cut() strip2d();
    for (i = [0 : 5]) translate([c3 + 85, m + i * 56]) cut() plate2d(i < 4);   // 4 outer, 2 middle (nest stale: re-nest with the pan)
    translate([c3, m + 336]) cut() tray_end2d();
    for (i = [0 : 1]) translate([c3 + i * 50 + 44.2, m + 386]) rotate(90) cut() tray_side2d();
}
if (part == "sheet") sheet();
else if (part == "gasket") for (i = [0 : 1]) translate([40, 25 + i * 40]) gasket2d();
else if (part == "cord_plug") cord_plug();

echo(str("sheet use: columns end at x ", c3 + 170, " (610); col 1 ends y ", m + deck_l + tun_l + 2 * g + 3 * 18,
         ", col 2 y ", m + dr[1] + tun_l + 2 * g + 50 + 18, ", col 3 y ", m + 386 + dr[1], " (914)"));
