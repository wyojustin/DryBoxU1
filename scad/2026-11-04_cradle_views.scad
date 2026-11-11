// 2026-11-04: views of the spool cradle (final fits: rod_d 8.25, bear_od 22.15) for review.
// Two cradles pinned together, each with 2 rollers on 608 bearings and 8 x 89 mm axles, one
// spool. view = "pair" | "section" (cut through one roller axis) | "exploded" | "pegs"
// (two cradles pulled 20 mm apart).
// Axes as the cradle file: x across the slot, y = 0 at the spool axis, z up from the floor.

use <2026-10-30_dry_box_cradle.scad>

view = "pair";

cradle_w = (640 - 2 * 5.8) / 7 - 0.2;
plate_t  = (cradle_w - 80) / 2;
roll_off = 65; roll_z = 20; roll_od = 28; boss = 1;
roll_len = 80 - 2 * boss - 0.4;
rod_len  = cradle_w - 0.6;
function axis_z(d) = roll_z + sqrt(pow(d / 2 + roll_od / 2, 2) - pow(roll_off, 2));

module bearing608() {
    color([0.75, 0.75, 0.78]) difference() {
        cylinder(d = 22, h = 7, $fn = 48);
        translate([0, 0, -1]) cylinder(d = 8, h = 9, $fn = 32);
        translate([0, 0, 6.6]) difference() { cylinder(d = 19, h = 1, $fn = 48); cylinder(d = 12, h = 1, $fn = 32); }
    }
}

module roller_set(s, e = 0) {   // e: explode distance
    translate([plate_t + boss + 0.2, s * roll_off, roll_z + e * 2.5]) rotate([0, 90, 0]) {
        color("steelblue") roller();
        translate([0, 0, -e]) bearing608();
        translate([0, 0, roll_len - 7 + e]) bearing608();
    }
    color([0.55, 0.55, 0.58]) translate([0.3 - e * 6, s * roll_off, roll_z + e * 2.5]) rotate([0, 90, 0])
        cylinder(d = 8, h = rod_len, $fn = 32);                 // axle, flush inside the plates
}

module one_cradle(explode = 0) {
    color([0.88, 0.88, 0.88]) cradle();
    for (s = [-1, 1]) roller_set(s, explode);
}

module spool_at(x) {
    color([0.95, 0.45, 0.35, 0.55]) translate([x, 0, axis_z(210)]) rotate([0, 90, 0]) difference() {
        cylinder(d = 210, h = 65, center = true, $fn = 120);
        cylinder(d = 55, h = 67, center = true, $fn = 48);
    }
}

if (view == "pair") {
    one_cradle();
    translate([cradle_w, 0, 0]) one_cradle();
    spool_at(cradle_w / 2);
} else if (view == "section") {
    difference() {
        one_cradle();
        translate([-10, roll_off, -10]) cube([cradle_w + 20, 100, 100]);   // cut on the back roller axis
    }
} else if (view == "pegs") {
    one_cradle();
    translate([cradle_w + 20, 0, 0]) one_cradle();
} else {
    one_cradle(explode = 10);
}
