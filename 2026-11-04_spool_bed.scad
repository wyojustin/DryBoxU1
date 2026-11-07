// 2026-11-04: laser-cut spool bed (concept). Replaces the 7 printed cradles.
// Only the 4 fed slots spin: slots 0-1 (left feeder) and 5-6 (right feeder) sit on printed
// rollers (608 bearings) carried by two continuous 8 mm rods per group (4 rods of ~180 mm,
// cut from 2 of the 400 mm rods), through 3 acrylic plates per group. The 3 spare slots (2-4)
// rest on fixed acrylic bars at the rollers' top height. Plates and strips interlock egg-crate
// fashion (notches from the bottom in the plates, from the top in the strips), cemented.
// Rod ends: against the box's side walls outside, against the next section's plate inside.
// part = "assembly" | "plate_roll" | "plate_spare" | "strip" | "bar" (2D outlines for the laser
// come later). Axes: x across the box from its inside left wall, y = 0 on the spool axes,
// z = 0 on the box floor. Units mm.

part = "assembly";

ta      = 5.8;                 // acrylic
inner_w = 640 - 2 * 5.8;       // 628.4 between the side walls
plate_l = 170; plate_h = 50; chamfer = 15;
roll_off = 65; roll_z = 20; roll_od = 28;
washer  = 1.0;                 // printed spacer washer: bearing inner race to plate
float   = 0.2;
rod_d   = 8.1;                 // laser hole for the 8 mm rod (slip)
n_plates = 3 + 4 + 3;          // left group, spare section, right group
gap     = (inner_w - n_plates * ta - 1) / 7;   // between plates, 1 mm total side play
roll_len = gap - 2 * (washer + float);

// plate left faces, from the inside of the left wall (0.5 mm play)
function px(i) = 0.5 + i * ta + (i - (i >= 3 ? 1 : 0) - (i >= 7 ? 1 : 0)) * gap;
// i: 0..9; plates 2|3 and 6|7 touch (section joints), so no gap is added there
roll_groups = [[0, 2], [7, 9]];          // first and last plate of each rolling group
spare_sec   = [3, 6];

strip_y = [-(plate_l / 2 - 8), plate_l / 2 - 8];   // base strips near the plate ends
strip_h = 12;
bar_h   = roll_z + roll_od / 2;          // spare bars' top = rollers' top (34)

module plate_profile() {   // in (y, z)
    polygon([[-plate_l / 2, 0], [plate_l / 2, 0], [plate_l / 2, plate_h - chamfer],
             [plate_l / 2 - chamfer, plate_h], [-plate_l / 2 + chamfer, plate_h],
             [-plate_l / 2, plate_h - chamfer]]);
}
module plate(rolling) {    // a plate standing in the y-z plane, thickness along x
    rotate([90, 0, 90]) linear_extrude(ta) difference() {
        plate_profile();
        if (rolling) for (s = [-1, 1]) translate([s * roll_off, roll_z]) circle(d = rod_d, $fn = 32);
        for (y = strip_y) translate([y - ta / 2, -1]) square([ta, strip_h / 2 + 1]);    // strip notches
        if (!rolling) for (s = [-1, 1]) translate([s * roll_off - ta / 2, -1]) square([ta, bar_h / 2 + 1]);
    }
}
module strip(x0, x1, y, h, notch_xs) {   // a strip on edge along x, notched from the top at plates
    translate([x0, y - ta / 2, 0]) difference() {
        cube([x1 - x0, ta, h]);
        for (nx = notch_xs) translate([nx - x0, -1, h / 2]) cube([ta, ta + 2, h]);
    }
}
module roller_set(x0) {    // roller with bearings and washers between plate faces at x0 .. x0 + gap
    for (s = [-1, 1]) {
        color("steelblue") translate([x0 + washer + float, s * roll_off, roll_z]) rotate([0, 90, 0])
            difference() { cylinder(d = roll_od, h = roll_len, $fn = 48); translate([0, 0, -1]) cylinder(d = 12, h = roll_len + 2, $fn = 24); }
        color([0.95, 0.55, 0.1]) for (wx = [x0, x0 + gap - washer]) translate([wx, s * roll_off, roll_z]) rotate([0, 90, 0])
            difference() { cylinder(d = 12, h = washer, $fn = 32); translate([0, 0, -1]) cylinder(d = 8.3, h = 3, $fn = 24); }
    }
}

module bed() {
    for (i = [0 : n_plates - 1]) {
        rolling = (i <= 2) || (i >= 7);
        color(rolling ? [0.85, 0.92, 1.0] : [0.78, 0.86, 0.98]) translate([px(i), 0, 0]) plate(rolling);
    }
    for (g = roll_groups) {
        x0 = px(g[0]); x1 = px(g[1]) + ta;
        for (s = [-1, 1]) color([0.55, 0.55, 0.58]) translate([x0, s * roll_off, roll_z]) rotate([0, 90, 0])
            cylinder(d = 8, h = x1 - x0, $fn = 32);                              // continuous rods
        for (i = [g[0] : g[1] - 1]) roller_set(px(i) + ta);
        for (y = strip_y) color([0.80, 0.88, 1.0]) strip(x0, x1, y, strip_h, [for (i = [g[0] : g[1]]) px(i)]);
    }
    xs0 = px(spare_sec[0]); xs1 = px(spare_sec[1]) + ta;
    for (y = strip_y) color([0.80, 0.88, 1.0]) strip(xs0, xs1, y, strip_h, [for (i = [spare_sec[0] : spare_sec[1]]) px(i)]);
    for (s = [-1, 1]) color([0.70, 0.80, 0.98]) strip(xs0, xs1, s * roll_off, bar_h, [for (i = [spare_sec[0] : spare_sec[1]]) px(i)]);
}

// slot centres (x) and spool axis heights: on rollers, or on the spare bars' top edges
slot_gap_after = [0, 1, 3, 4, 5, 7, 8];
function slot_x(k) = px(slot_gap_after[k]) + ta + gap / 2;
function spool_z(rolling, d) = rolling ? roll_z + sqrt(pow(d / 2 + roll_od / 2, 2) - pow(roll_off, 2))
                                       : bar_h + sqrt(pow(d / 2, 2) - pow(roll_off, 2));
module spools(d = 210, w = 65) {
    for (k = [0 : 6]) {
        rolling = k <= 1 || k >= 5;
        color(rolling ? [0.95, 0.45, 0.35, 0.5] : [0.85, 0.75, 0.55, 0.5])
            translate([slot_x(k), 0, spool_z(rolling, d)]) rotate([0, 90, 0]) difference() {
                cylinder(d = d, h = w, center = true, $fn = 96);
                cylinder(d = 55, h = w + 2, center = true, $fn = 32);
            }
    }
}

if (part == "plate_roll") plate(true);
else if (part == "bed_spools") { bed(); spools(); }
else if (part == "plate_spare") plate(false);
else bed();

echo(str("gap ", gap, ", roller ", roll_len, "; rod per group ", px(2) + ta - px(0),
         "; feeder-pair centres (plate 1, 8 mid) ", px(1) + ta / 2 + 5.8, ", ", px(8) + ta / 2 + 5.8,
         " (box x; feeders at 95.57, 544.43)"));
