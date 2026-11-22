// 2026-11-16: split threaded cable gland for the mixing fan's USB cable, in place of the PG13.5
// in the back panel's 19.8 cord hole (panels file, cord_hole()). The fan's USB plug is too big for
// the PG13.5, so: take the PG13.5 out, slide the nut onto the cable from the plug end (plug first),
// push the plug out through the bare 19.8 hole, close the 2 half shells around the cable from
// outside (flange outside, on the EVA ring from 2026-11-05_interior.scad cord_ring2d), and screw
// the nut on from inside. The nut holds the halves together and pulls the flange into the EVA.
// 2026-11-16: 2 EVA rings (part = "gaskets", laser): one under the flange outside, one under the nut
// inside. Both go onto the cable from the plug end too: nut, inner ring, then out through the panel,
// outer ring. The shank was not lengthened for the inner ring: the nut still gets 7.5 of thread.
// Seal: a thin film of RTV or butyl on the halves' split faces and in the cable groove at assembly.
// Two 1.75 mm filament snips in the dowel holes keep the halves from sliding along each other.
// Two halves, left and right (2026-11-16: not one part printed twice: a single-start thread turned
// 180 degrees about its axis lands half a pitch off, Justin's first print). Thread: single start,
// rounded (twisted offset circle), right hand.
// PLACEHOLDERS until the fan arrives (2026-11-16, fan and controller on order): cable_d, plug, sw.
// Measure them and dial in; the echo at the bottom checks the plug and switch against the nut.
// part = "left" | "right" (each prints on its flat split face) | "nut" (print flat) | "view" (assembled, cut away)
//      | "gaskets" (2 EVA rings, 2D for the laser)
// Units mm. z along the cable, z = 0 at the flange's outer face, +z into the box.

part = "view";

// --- measure when the fan arrives ---
cable_d  = 2.9;           // USB cable diameter, measured on the fan (Justin, 2026-11-17; was 3.6 from the listing)
plug     = [15.3, 7.6];   // USB-A plug molded body, width x thickness (Justin, 2026-11-16)
sw       = [14, 9];       // PLACEHOLDER: inline switch, width x thickness (only decides which side it ends up)
squeeze  = 0;             // cable groove under cable_d (2026-11-17: 0.3 held the halves apart, the nut would not start; printed grooves come out a little tight anyway)

// --- box ---
hole_d   = 19.8;          // cord hole (panels file)
panel_t  = 5.8;           // acrylic, caliper-mapped
eva_t    = 2;             // EVA ring under the flange (and one under the nut), compressed

// --- thread ---
pitch    = 1.5;
d_maj    = 19.4;          // must pass the 19.8 hole
depth    = 0.75;          // rounded thread, radial
clr      = 0.4;           // nut over shank, on the diameter
d_min    = d_maj - 2 * depth;
ring_id  = d_maj + 0.8;   // EVA ring bore: slips over the thread (and the plug)

// --- parts ---
fl_d     = 30;            // flange = EVA ring OD (cord_ring2d: 19.8 + 10)
fl_t     = 4;
nut_h    = 8;
nut_d    = 28;
shank_l  = eva_t + panel_t + nut_h + 1.5;   // past the flange
dowel_d  = 2.0;           // 1.75 filament, loose
dowel_x  = 6;             // either side of the cable
dowel_l  = 3;             // depth into each half

module thread_rod(d1, d2, l) {             // rounded thread between diameters d2 (root) and d1 (crest)
    R = (d1 + d2) / 4; e = (d1 - d2) / 4;
    linear_extrude(l, twist = -360 * l / pitch, slices = ceil(l / pitch * 24), convexity = 6)
        translate([e, 0]) circle(r = R, $fn = 96);
}

module body() difference() {              // the whole gland body, before the split
    union() {
        cylinder(d = fl_d, h = fl_t, $fn = 96);
        translate([0, 0, fl_t - 0.01]) intersection() {
            thread_rod(d_maj, d_min, shank_l);
            cylinder(d1 = d_maj + 2 * shank_l - 2, d2 = d_min - 0.4 + 0.01, h = shank_l, $fn = 96);   // chamfered start
        }
    }
    translate([0, 0, -1]) cylinder(d = cable_d - squeeze, h = fl_t + shank_l + 2, $fn = 32);
    for (zz = [-0.01, fl_t + shank_l - 0.8])                           // ease the groove's ends
        translate([0, 0, zz]) cylinder(d1 = cable_d + (zz < 0 ? 1.6 : 0), d2 = cable_d + (zz < 0 ? 0 : 1.6), h = 0.81, $fn = 32);
    for (s = [-1, 1]) translate([s * dowel_x, 0, fl_t + shank_l / 2]) rotate([90, 0, 0])
        cylinder(d = dowel_d, h = 2 * dowel_l, center = true, $fn = 24);
}

module half(s) intersection() {          // s = 1: y >= 0 (left), s = -1: y <= 0 (right); both cut from the one body
    body();
    translate([-fl_d, s > 0 ? 0 : -fl_d, -1]) cube([2 * fl_d, fl_d, fl_t + shank_l + 2]);
}

module nut() difference() {
    union() {
        cylinder(d = nut_d - 3, h = nut_h, $fn = 96);
        for (a = [0 : 30 : 359]) rotate(a) translate([nut_d / 2 - 2, 0, 0]) cylinder(d = 4, h = nut_h, $fn = 24);   // finger grip
    }
    translate([0, 0, -0.01]) thread_rod(d_maj + clr, d_min + clr, nut_h + 0.02);
    for (zz = [0, nut_h]) translate([0, 0, zz]) cylinder(d = d_maj + clr + 1.4, h = 1.4, center = true, $fn = 96);   // chamfers
}

if (part == "left") rotate([90, 0, 0]) half(1);                  // split face on the bed
else if (part == "right") rotate([-90, 0, 0]) half(-1);
else if (part == "nut") nut();
else if (part == "gaskets") for (i = [0 : 1]) translate([5 + fl_d / 2 + i * (fl_d + 3), 5 + fl_d / 2]) difference() {
    circle(d = fl_d, $fn = 96);
    circle(d = ring_id, $fn = 96);
}
else if (part == "view") difference() {
    union() {
        color("dimgray") half(1); color("gray") half(-1);
        color("red") translate([0, 0, fl_t + 2 * eva_t + panel_t]) nut();
        color("tan") translate([0, 0, fl_t + eva_t + panel_t]) difference() {
            cylinder(d = fl_d, h = eva_t, $fn = 64);
            translate([0, 0, -1]) cylinder(d = ring_id, h = eva_t + 2, $fn = 64);
        }
        color([0.8, 0.9, 1, 0.5]) translate([0, 0, fl_t + eva_t]) difference() {
            translate([-25, -25, 0]) cube([50, 50, panel_t]);
            translate([0, 0, -1]) cylinder(d = hole_d, h = panel_t + 2, $fn = 64);
        }
        color("tan") translate([0, 0, fl_t]) difference() {
            cylinder(d = fl_d, h = eva_t, $fn = 64);
            translate([0, 0, -1]) cylinder(d = ring_id, h = eva_t + 2, $fn = 64);
        }
        color("black") translate([0, 0, -20]) cylinder(d = cable_d, h = fl_t + shank_l + 40, $fn = 24);
    }
    translate([0, -50, -50]) cube([100, 50, 100]);                 // cut away the front for the view
}

nut_bore = d_min + clr;
echo(str("gland: thread ", d_maj, " x ", pitch, " (root ", d_min, "), hole ", hole_d, "; nut bore ", nut_bore,
         ", plug diagonal ", norm(plug), (norm(plug) < nut_bore ? " PASSES" : " DOES NOT PASS"), " the nut",
         (norm(plug) < hole_d ? " and passes" : " and DOES NOT PASS"), " the hole; switch diagonal ", norm(sw),
         (norm(sw) < nut_bore ? " passes the nut (can end up outside)" : " stays inside (nut goes on between it and the plug)"),
         "; shank ", shank_l, ", nut ", nut_h, " on ", shank_l - eva_t - panel_t, " of thread (", shank_l - 2 * eva_t - panel_t, " with the inner ring); EVA rings ", fl_d, " x ", ring_id));
