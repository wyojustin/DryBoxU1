// 2026-11-05: acrylic inside the box: tunnel (floor, 2 walls, perforated deck) around the bought
// desiccant pan, and the 2 spool holders' plates and strips. One source for these sizes: the
// assembly draws them and its cut list prints them from here. Butt joints, solvent cement.
// NEXT TIME (2026-11-12, not applied; the current cut files are butt joints): the butt-jointed
// tunnel needed printed jigs (2026-11-11_tunnel_jig.scad) to hold it straight for gluing. On a
// re-cut, give the walls tabs along their top and bottom edges into through-slots in the deck and
// floor, like the shell's finger joints. The walls can then only land at tun_in apart and the
// glue-up squares itself, with no jigs. Keep the slots clear of the deck holes and the vents, and use
// the looser kerf (about 0.20; 0.25 needed a mallet on the shell).
// 2026-11-11: pan measured (SS6152): 153 x 384 x 51, straight walls (153 across the top is the
// widest), wire handles stand 9 off each end (402 overall), 5 mm wire, its underside 6.5 above
// the pan's bottom. The acrylic tray is dropped. Nested on 908-long pieces (cut with the film off):
// part = "floor_deck" (rip from sheet 1, at least 176 wide) | "walls_strips" (166 offcut)
//      | "plates" (154 offcut) | "gasket" (2 feeder gaskets, EVA) | "cord_plug" (spare).
// Units mm. Pieces lie flat, corner at the origin.

use <2026-10-30_dry_box_panels.scad>
use <2026-11-04_spool_holder.scad>

part = "floor_deck";

sd = shell_dims();
X = sd[0]; Y = sd[1]; Z = sd[2]; t = sd[3]; ext = sd[4];
back_in = Y - t;
dr      = [153, 384, 51]; dr_air = 25;    // pan body x, y, z (measured); air gap above it
pan_so  = 9; pan_wire = [5, 6.5];         // handle stand-off past each end; wire d, its underside above the pan bottom
tun_in  = dr[0] + 4;                      // between the tunnel walls: 2 clear per side
tun_w   = tun_in + 2 * t;
tun_l   = back_in - ext - 0.5;            // floor and walls: back wall to the front frame member
deck_l  = back_in - 1;                    // deck: runs on over the frame member
wall_h  = dr[2] + dr_air;
vent_d  = 16; vent_p = 32;
deck_d  = 12; deck_p = 24;

function int_dr()  = dr;
function int_pan_hdl() = [pan_so, pan_wire[0], pan_wire[1] + pan_wire[0] / 2];   // stand-off, wire d, lower wire centre z
function int_air() = dr_air;
function int_tun() = [tun_in, tun_w, tun_l, deck_l, wall_h];

module deck2d() difference() {            // holes stay clear of the walls below (5 across: 24 in from each wall)
    square([tun_w, deck_l]);
    for (ix = [-2 : 2], iy = [0 : 15]) translate([tun_w / 2 + ix * deck_p, 29 + iy * deck_p]) circle(d = hole(deck_d), $fn = 32);
}
module floor2d() square([tun_w, tun_l]);
module wall2d() difference() {            // x along the box's depth, y up; vents in the air gap
    square([tun_l, wall_h]);
    for (y = [21.5 : vent_p : tun_l - 10]) translate([y, wall_h - dr_air / 2]) circle(d = hole(vent_d), $fn = 48);
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

// 2026-11-14: full feeder gasket, EVA: covers the whole outlet face, 56.6 tall x the same 54 wide
// as gasket2d. Top edge at the feeder's top (the top panel's underside); collets 40 and case
// screws 30 below it (panels file). Origin at the gasket's top center, y down is negative.
gf_h = 56.6; gf_w = 26 + 16 + 12;          // 54, gasket2d's outside width
module gasket_full2d() {
    pd = 26; cd = 46.9;
    difference() {
        translate([-gf_w / 2, -gf_h]) offset(r = 3, $fn = 32) offset(delta = -3) square([gf_w, gf_h]);
        hull() for (s = [-1, 1]) translate([s * pd / 2, -40]) circle(d = 16.4, $fn = 48);
        for (s = [-1, 1]) translate([s * cd / 2, -30]) circle(d = 3.2, $fn = 32);
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

// nests on 908-long pieces, x along the 908, y = 0 on the factory (or straightest) edge
L = 908; m = 5; g = 3;
module cut() offset(delta = 0.125) children();
module along(l) translate([l, 0]) rotate(90) children();   // a [w, l] piece turned to lie along x
module floor_deck() {                    // rip from sheet 1: needs m + tun_w + 2 = 175.6
    translate([m, m]) along(deck_l) cut() deck2d();
    translate([m + deck_l + 2 * g, m]) along(tun_l) cut() floor2d();
}
module walls_strips() {                  // 166 offcut: walls side by side, then the 4 holder strips
    for (i = [0 : 1]) translate([m, m + i * (wall_h + g)]) cut() wall2d();
    for (i = [0 : 3]) translate([m + tun_l + 2 * g, m + i * (35 + g)]) cut() strip2d();
}
module plates() {                        // 154 offcut: 4 outer + 2 middle, 2 rows of 3
    for (i = [0 : 5]) translate([m + 88 + (i % 3) * (176 + g), m + floor(i / 3) * (50 + g)]) cut() plate2d(i < 4);
}
if (part == "floor_deck") floor_deck();
else if (part == "walls_strips") walls_strips();
else if (part == "plates") plates();
else if (part == "gasket") for (i = [0 : 1]) translate([40, 25 + i * 40]) gasket2d();
else if (part == "gasket_full") for (i = [0 : 1]) translate([5 + gf_w / 2 + i * (gf_w + 3), 5 + gf_h]) gasket_full2d();
else if (part == "cord_plug") cord_plug();

echo(str("floor_deck: x to ", m + deck_l + 2 * g + tun_l, " of ", L, ", y to ", m + tun_w,
         "; walls_strips: y to ", m + 2 * wall_h + g,
         "; plates: y to ", m + 2 * 50 + g, "; tunnel in ", tun_in, " x wall ", wall_h, "; pan ", dr, " + ", 2 * pan_so));
