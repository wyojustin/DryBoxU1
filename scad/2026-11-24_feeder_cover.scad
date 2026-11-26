// 2026-11-24: covers for the U1's side panels where the two feeders were (they now hang in the dry box).
// SUPERSEDED 2026-11-25 by 2026-11-25_feeder_blank_cover.scad (a snap leg broke on the fit test; the new cover hooks in).
// Kept because the new file uses this file's panel, adapter board and cable mock-up for its views and clash checks.
// Step 1: "fit_test", a thin frame with the four snap legs only. The cover itself comes after the legs fit.
// The panel's pattern on one side is the other side's turned 180 degrees, so one leg layout fits both.
// Legs: each window takes two springy prongs, pushed straight in (no sliding like the feeder's hooks).
// Their outer faces (toward front and rear) widen from the root to a peak, then ramp in at the tip, so the
// window's edge always rides on the slope and the spring pulls the frame toward the panel, whatever the
// wall thickness is up to peak_z (the feeder's hooks spanned 5.0 and 6.7). Each prong starts root_in below the frame's
// face, in a moat, to make it longer and softer. Nothing hangs on the legs; pull to remove.
// Axes: x along the panel toward the printer's rear, y up the panel, z = 0 the panel's face, -z into it.
// Measured (printer, for the feeder insert): wide windows 11.8 x 8.0, 38.5 apart in y; narrow 9.0 x 8.5,
// 38.35 apart; 27.0 between the pairs. Measured 2026-11-24: cable slot 9.6 x 28.7, channel 1.5 deep,
// adapter board with plugs 30 x 28 x 6; "rear to window: 30mm radius round" (read as a 30 radius behind the narrow windows).
// part = "fit_test" (as printed, frame down, legs up) | "view" (MOCK-UP of a hood cover on the side panel, with the
// adapter board and cable; gap = how far the cover is pulled off, cut = true takes the cover's front away). Units mm.
part = "fit_test";

WIN = [   // x centre, y centre, size x, size y
    [ 0,  38.5 / 2,  11.8, 8.0], [ 0, -38.5 / 2,  11.8, 8.0],
    [27,  38.35 / 2,  9.0, 8.5], [27, -38.35 / 2,  9.0, 8.5] ];
clr    = 0.2;    // leg to window, each side
leg_l  = 6.8;    // below the panel's face (the feeder's shorter hooks reached 6.9)
leg_t  = 1.2;    // prong thickness
peak   = 0.4;    // how far the prong's outer face sticks out past its root: 0.2 squeeze per prong
peak_z = 5.3;    // depth of the peak
root_in = 2;     // prong root, this far into the frame
moat   = 0.9;
fr_t   = 3;      // frame thickness
fr_x   = [-7.6, 33]; fr_y = 26;   // stops short of the cable slot in front, just past the round's start behind
bar    = 13.5;   // frame bar along x, over the windows

module prong(w) {   // outer face toward +x; w = [size x, size y]
    xo = w[0] / 2 - clr;
    rotate([90, 0, 0]) translate([0, 0, -(w[1] / 2 - clr)]) linear_extrude(height = w[1] - 2 * clr)
        polygon([[xo - leg_t, fr_t], [xo, fr_t], [xo, -0.5], [xo + peak, -peak_z], [xo + peak, -peak_z - 0.2],
                 [xo - 0.4, -leg_l], [xo - leg_t, -leg_l]]);
}
module legs() for (w = WIN) translate([w[0], w[1], 0]) for (a = [0, 1]) mirror([a, 0, 0])
    intersection() { prong([w[2], w[3]]); translate([-20, -20, -20]) cube([40, 40, 20 + root_in + 0.5]); }
module moats() for (w = WIN) translate([w[0], w[1], 0]) for (a = [0, 1]) mirror([a, 0, 0]) {
    xo = w[2] / 2 - clr;
    translate([xo - leg_t - moat, -w[3] / 2 - 0.3, -1]) cube([leg_t + 2 * moat, w[3] + 0.6, root_in + 1]);
}
module frame() linear_extrude(height = fr_t) difference() {
    offset(r = 3, $fn = 32) offset(delta = -3) translate([fr_x[0], -fr_y]) square([fr_x[1] - fr_x[0], 2 * fr_y]);
    offset(r = 3, $fn = 32) offset(delta = -3) translate([fr_x[0] + 8, -fr_y + bar]) square([fr_x[1] - fr_x[0] - 16, 2 * (fr_y - bar)]);
}
module fit_test() { difference() { frame(); moats(); } legs(); }

// ---------------- mock-up: hood over the openings and the adapter board (not a part to print yet) ----------------
// 2026-11-25, as taped up in the photo: the board sits behind the slot, between the two rows of windows, its
// cable from the slot into its front plug, the ribbon out of its rear plug and around the printer's rear corner.
// Angular: a flat top and flat sides that flare toward the panel, ending at the seam where the rear rounds off.
// The hood is the same above and below y = 0, so one part fits both sides (turn it 180).
gap = 0; cut = false; show_cover = true;
left = true;                                      // show the left side panel, as in the photo
slot_x  = [-7.9 - 9.6, -7.9]; slot_h = 28.7;      // position from the 2026-11-25 photo
chan    = [21, 1.5];                              // height from a photo
rnd     = [38.5, 30];                             // seam, where the rounded rear piece starts (from the ruler photos, +-0.7); radius TO CONFIRM
board   = [24, 28, 6]; plug = 3; bd_c = [18.5, 0];  // body + a plug at each end = 30 along x; 28 between the window rows (29.85)
cov_x   = [-25, 38]; cov_y = 28;                  // base on the panel: over the latch notch in front, to the seam behind
flare   = 3.5;                                    // the flat top is this much smaller all around, so the sides are trapezoids
cov_h   = 9.5; cov_w = 2;                         // off the panel, wall
rib_w   = 16;                                     // ribbon, photo estimate
module fr_at(d, z) translate([cov_x[0] + d, -cov_y + d, z]) cube([cov_x[1] - cov_x[0] - 2 * d, 2 * cov_y - 2 * d, 0.001]);
module frustum(d, h) hull() { fr_at(d, 0); fr_at(d + flare * h / cov_h, h - 0.001); }
module cov_in() { translate([0, 0, -0.5]) frustum(cov_w / cos(atan(flare / cov_h)) - flare * 0.5 / cov_h, cov_h - cov_w + 0.5); }
module panel_body(d = 0) translate([0, 100, 0]) rotate([90, 0, 0]) linear_extrude(height = 200) {   // the panel's solid side, d outward
    translate([-100, -60]) square([100 + rnd[0], 60 + d]);
    translate([rnd[0], -rnd[1]]) circle(r = rnd[1] + d, $fn = 240);
    translate([rnd[0], -60]) square([rnd[1] + d, 60 - rnd[1]]);
}
module cover() {
    difference() {
        frustum(0, cov_h);
        cov_in();
        translate([cov_x[1] - 6, -(rib_w + 2) / 2, -1]) cube([20, rib_w + 2, 1 + 3.5]);      // ribbon out at the rear
    }
    difference() {
        intersection() {
            for (w = WIN) translate([w[0], 0, 0]) mirror([0, w[1] < 0 ? 1 : 0, 0])     // not past the window on the board's side
                translate([-w[2] / 2 - 1.5, abs(w[1]) - w[3] / 2, 0]) cube([w[2] + 3, w[3] + 1.5, cov_h - cov_w + 0.5]);
            frustum(0.5, cov_h);
        }
        moats();
    }
    legs();
}
module panel() color([0.86, 0.86, 0.85]) difference() {
    intersection() { panel_body(0); translate([-60, -70, -25]) cube([125, 140, 30]); }
    translate([-70, -80, -40]) cube([90, 160, 37]);                                   // hollow behind the flat part
    for (w = WIN) translate([w[0] - w[2] / 2, w[1] - w[3] / 2, -9]) cube([w[2], w[3], 10]);
    translate([slot_x[0], -slot_h / 2, -5]) cube([slot_x[1] - slot_x[0], slot_h, 10]);
    translate([slot_x[1], -chan[0] / 2, -chan[1]]) cube([60, chan[0], 5]);
    translate([-22, -25, -1.5]) cube([11.2, 4.2, 5]);
}
module adapter() {
    color([0.15, 0.2, 0.25]) translate([bd_c[0] - board[0] / 2, bd_c[1] - board[1] / 2, 0.5]) cube(board);
    color("white") for (x = [-board[0] / 2 - plug, board[0] / 2]) translate([bd_c[0] + x, bd_c[1] - 9, 1.5]) cube([plug, 18, 4]);
    color("silver") for (y = [-10, 10]) translate([bd_c[0], bd_c[1] + y, 0.5]) cylinder(d = 4, h = board[2] + 0.3, $fn = 32);
}
module path(P, w) for (i = [0 : len(P) - 2]) hull() for (q = [P[i], P[i + 1]]) translate([q[0], -w / 2, q[1]]) rotate([-90, 0, 0]) cylinder(d = 1, h = w, $fn = 12);
module cable() color([0.08, 0.08, 0.08]) {
    path([[-14, -8], [-13.8, 0], [-12.5, 4], [-10, 5.8], [-7, 6], [-4, 5], [bd_c[0] - board[0] / 2 - plug, 3.5]], 10);   // slack pushed back into the slot
    path(concat([[bd_c[0] + board[0] / 2 + plug, 3]], [[rnd[0], 0.8]], [for (a = [5 : 5 : 75]) [rnd[0] + (rnd[1] + 0.7) * sin(a), -rnd[1] + (rnd[1] + 0.7) * cos(a)]]), rib_w);
}
module view() rotate([0, 0, left ? 180 : 0]) {
    panel(); adapter(); cable();
    if (show_cover) translate([0, 0, gap]) color([0.85, 0.1, 0.1]) difference() {
        cover();
        if (cut) translate([-100, -100, 4]) cube([200, 200, 20]);
    }
}
if (part == "view") view();
if (part == "fit_test") translate([0, 0, fr_t]) mirror([0, 0, 1]) fit_test();
