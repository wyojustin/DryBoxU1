// 2026-10-30: spool roller cradle for the dry box, one per slot (7 per box).
// Two end plates carry two rollers (printed sleeves on 608 bearings, 8 mm rod axles); the spool's
// rims ride on the rollers and the end plates keep it in its slot. Cradles pin together
// into a row that fills the box's inside width. The axle rods are cut just short of the
// cradle width and sit flush: neighboring cradles (and the box walls at the ends) keep
// them from sliding out, so nothing sticks out between slots. Print in PLA, base down.
// part = "cradle" | "roller" | "assembly". Axes: x = across the slot, y = front to back
// (y = 0 is the spool axis), z = up from the box floor. Units mm.

part = "assembly";

// spools: standard 1 kg size; the U1's 500 g spools are 200 x 50.4 (45.5 between rims)
spool_d   = [195, 210];
spool_w   = [50, 72];

pitch     = (640 - 2 * 5.8) / 7;    // slot pitch in the box (t = 5.8), 89.77
cradle_w  = pitch - 0.2;            // neighbors touch; the row of 7 leaves ~1.4 mm slack
gap       = 80;                     // between end plates: widest spool + 4 mm each side
plate_t   = (cradle_w - gap) / 2;   // 4.8
plate_l   = 170;                    // along y
plate_h   = 50;
chamfer   = 15;

roll_off  = 65;                     // roller axes at y = +-roll_off
roll_z    = 20;                     // roller axis height above the box floor
roll_od   = 28;
boss      = 1;                      // spacer bosses: plates clamp only the bearing inner races
boss_d    = 11;
roll_len  = gap - 2 * boss - 0.4;   // 0.2 mm end float each side

bear_od   = 22.15;                  // 608: 22 x 8 x 7; 2026-11-03 fit gauge pocket 2, snug by hand
bear_w    = 7;
rod_d     = 8.25;                   // hole for the 8 mm rod: 2026-11-04 fit gauge, rod (8.00) slides in hole 3
rod_len   = cradle_w - 0.6;         // 88.97: flush inside the plate outer faces

rail_w    = 10;
rail_h    = 6;
peg_d     = 5;
peg_l     = 3;
peg_yz    = [[-50, 12], [50, 12], [0, 38]];   // 2026-11-03: third peg high, stops the row rocking

// spool axis height for a spool of diameter d resting on both rollers
function axis_z(d) = roll_z + sqrt(pow(d / 2 + roll_od / 2, 2) - pow(roll_off, 2));

for (d = spool_d)
    echo(str("spool ", d, ": axis z ", axis_z(d), ", rim bottom z ", axis_z(d) - d / 2,
             ", top z ", axis_z(d) + d / 2, " (box inside top 246.4 above floor)"));
echo(str("cradle ", cradle_w, " x ", plate_l, " x ", plate_h, "; plate ", plate_t,
         "; roller ", roll_od, " x ", roll_len, "; rod 8 x ", rod_len, " (14 per box)",
         "; row of 7 = ", 7 * cradle_w, " of 628.4"));

module plate_shape() {   // in (y, z)
    polygon([[-plate_l / 2, 0], [plate_l / 2, 0], [plate_l / 2, plate_h - chamfer],
             [plate_l / 2 - chamfer, plate_h], [-plate_l / 2 + chamfer, plate_h],
             [-plate_l / 2, plate_h - chamfer]]);
}

module plate(x0, inner_sign) {
    translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(plate_t) plate_shape();
    // spacer bosses on the inner face
    for (s = [-1, 1])
        translate([inner_sign > 0 ? x0 + plate_t : x0 - boss, s * roll_off, roll_z])
            rotate([0, 90, 0]) cylinder(d = boss_d, h = boss, $fn = 32);
}

module cradle() {
    x_l = 0;                          // left plate outer face
    x_r = cradle_w - plate_t;         // right plate inner face
    difference() {
        union() {
            plate(x_l, 1);
            plate(x_r, -1);
            // base rails at the front, back and middle
            for (y = [-plate_l / 2, -rail_w / 2, plate_l / 2 - rail_w])
                translate([plate_t, y, 0]) cube([gap, rail_w, rail_h]);
            // pegs on the right outer face
            for (p = peg_yz) translate([cradle_w, p[0], p[1]]) rotate([0, 90, 0])
                cylinder(d = peg_d, h = peg_l, $fn = 24);
        }
        // axle holes through both plates and bosses
        for (s = [-1, 1]) translate([cradle_w / 2, s * roll_off, roll_z])
            rotate([0, 90, 0]) cylinder(d = rod_d, h = cradle_w + 2, center = true, $fn = 32);
        // peg holes in the left outer face
        for (p = peg_yz) translate([-0.01, p[0], p[1]]) rotate([0, 90, 0])
            cylinder(d = peg_d + 0.4, h = peg_l + 0.5, $fn = 24);
    }
}

module roller() {   // prints standing on end
    difference() {
        cylinder(d = roll_od, h = roll_len, $fn = 64);
        translate([0, 0, -1]) cylinder(d = 12, h = roll_len + 2, $fn = 32);
        for (z = [-0.01, roll_len - bear_w]) translate([0, 0, z])
            cylinder(d = bear_od, h = bear_w + 0.01, $fn = 64);
    }
}

module spool(d, w) {
    %translate([cradle_w / 2, 0, axis_z(d)]) rotate([0, 90, 0]) difference() {
        cylinder(d = d, h = w, center = true, $fn = 96);
        cylinder(d = 55, h = w + 2, center = true, $fn = 48);
    }
}

if (part == "cradle") cradle();
else if (part == "roller") roller();
else {
    color("lightgray") cradle();
    color("steelblue") for (s = [-1, 1])
        translate([plate_t + boss + 0.2, s * roll_off, roll_z]) rotate([0, 90, 0]) roller();
    spool(200, 50.4);
}
