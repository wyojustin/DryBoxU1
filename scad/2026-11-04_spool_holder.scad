// 2026-11-04: laser-cut spool holder, 2 per box (identical, one against each side wall).
// Each holder spins 2 spools (the pair one feeder serves): 3 acrylic plates, 4 printed rollers
// on 608 bearings, front and back 8 mm rods running through all 3 plates. Both holders' rods
// come from ONE 400 mm rod each (2 x 189 mm per rod), so the 4 spinning spools use 2 rods.
// The spare spools lie flat, stacked, on the floor between the holders.
// Plates and base strips interlock egg-crate fashion (notches from the bottom in the plates,
// from the top in the strips), solvent-cemented. Rod ends: printed push-on end caps at both
// ends of every rod (8 caps), seated against the outer plate faces.
// part = "holder" | "box" (both holders + spools in the box's floor area) | "plate" | "strip"
//      | "cap" (print 8: open end down, no supports).
// Axes: x across the holder from its outer plate face, y = 0 on the spool axes, z = 0 on the
// floor. Units mm.

part = "box";
show_caps = true;               // false: hide the rod end caps (to see the rod ends)
show_rollers = true;            // false: hide rollers and washers (to see the whole rod)

ta      = 5.8;                  // acrylic
gap     = 82;                   // between plates: spools up to ~76 wide
plate_h = 50; chamfer = 15;
roll_off = 65; roll_z = 20; roll_od = 28;
waist   = 0;                    // roller radius drop at its middle: 0, a concave roller would steer the spool outward
washer  = 1.0; float = 0.2;     // printed washer on the inner race, end float
rod_d   = 8.25;                 // laser hole, drawn size: cuts to about 8.1 with the kerf offset, 8 mm rod slip fit
strip_h = 35;                   // 2026-11-11: 12 -> 35 (Justin: more strength and glue area); rims of
                                // 200-210 spools pass about 25 above it at the strip
strip_gap = 3.2;                // strip inner face to the roller's reach (roll_off + roll_od / 2 = 79)
// 2026-11-11 (Justin): strips flush with the plate ends, joints open-ended (no thin leg outside them)
plate_l = 2 * (roll_off + roll_od / 2 + strip_gap + ta);   // 176
// 2026-11-11 (Justin): strip ends are TABS in open-ended slots at the outer plates' ends (flush with
// the outer face); shoulders above and below butt the plate's inner face. The middle plate keeps the
// half-lap, open at the plate end. Assembly: middle plate drops onto the strips, outer plates slide on.
tab_z   = [6, strip_h - 6];     // tab height range on the strip (23 tall, 6 shoulders)
slot_w  = ta + 0.1;             // slot across the plate, for 5.8 acrylic (solvent cement wants snug)
cap_d   = 14; cap_t = 4;        // end cap: disc 14 x 4 (3 mm blind bore + 1 mm face)
cap_bore = 8.6; cap_rib = 0.4;  // bore with 3 crush ribs at 7.8 nominal (8.1 slid off freely, 6.9 would not go on)
strip_y = [-(plate_l / 2 - ta / 2), plate_l / 2 - ta / 2];   // +-85.1: flush with the plate ends, 3.2 clear of the rollers

W        = 3 * ta + 2 * gap;    // holder width (outer plate face to outer plate face)
// 2026-11-11: the rod runs rod_in past each outer plate face and BOTTOMS in the cap's 3 mm blind
// bore before the cap reaches the acrylic (Justin: a solid stop on the rod, not on the plate).
// 189 nominal, saw +-1: 188 to 190 = 3.3 to 4.3 past each plate, so the cap stands 0.3 to 1.3 off
// the plate (0.8 nominal). The holder sits far enough from the wall for the worst case.
cap_in   = cap_t - 1;           // blind bore depth, 3
rod_in   = 3.8;
rod_len  = W + 2 * rod_in;      // 189.0
cap_off  = rod_in - cap_in;     // cap stand-off from the outer plate, nominal 0.8 (0.3 to 1.3)
wall_off = 0.5 + cap_t + cap_off + 0.5;   // outer plate face to the box wall: 0.5 left at the worst cut (5.8)
function holder_rod_len() = rod_len;
function holder_wall_off() = wall_off;
function holder_plate_l() = plate_l;
roll_len = gap - 2 * (washer + float);
function plate_x(i) = i * (ta + gap);
function slot_x(k)  = ta + gap / 2 + k * (ta + gap);
function spool_z(d) = roll_z + sqrt(pow(d / 2 + roll_od / 2, 2) - pow(roll_off, 2));

module plate_profile() {
    polygon([[-plate_l / 2, 0], [plate_l / 2, 0], [plate_l / 2, plate_h - chamfer],
             [plate_l / 2 - chamfer, plate_h], [-plate_l / 2 + chamfer, plate_h],
             [-plate_l / 2, plate_h - chamfer]]);
}
module plate2d(outer = true) {   // outer plates: closed slots for the strip tabs; middle: half-lap notches
    difference() {
        plate_profile();
        for (s = [-1, 1]) translate([s * roll_off, roll_z]) circle(d = rod_d, $fn = 32);
        for (y = strip_y)
            // open to the plate end: the cut runs 1 past it (slot_w - ta = 0.1 extra on the inside only)
            if (outer) translate([y < 0 ? -plate_l / 2 - 1 : y - ta / 2 - (slot_w - ta), tab_z[0]])
                square([slot_w + 1, tab_z[1] - tab_z[0]]);
            else translate([y < 0 ? -plate_l / 2 - 1 : y - ta / 2, -1]) square([ta + 1, strip_h / 2 + 1]);
    }
}
module strip2d() {   // base strip (lies along x): end tabs into the outer plates, half-lap at the middle plate
    difference() {
        square([W, strip_h]);
        translate([plate_x(1), strip_h / 2]) square([ta, strip_h]);
        for (x = [0, W - ta]) for (z = [[-1, tab_z[0]], [tab_z[1], strip_h + 1]])
            translate([x - (x == 0 ? 1 : 0), z[0]]) square([ta + 1, z[1] - z[0]]);
    }
}

module cap() {   // printed open end down; ribs crush as it is pushed onto the rod
    difference() {
        union() {
            cylinder(d = cap_d, h = cap_t - 1, $fn = 48);
            translate([0, 0, cap_t - 1]) cylinder(d1 = cap_d, d2 = cap_d - 2, h = 1, $fn = 48);   // chamfered face
        }
        translate([0, 0, -1]) difference() {
            cylinder(d = cap_bore, h = cap_t - 1 + 1, $fn = 48);
            for (a = [0, 120, 240]) rotate(a) translate([cap_bore / 2 - cap_rib, -0.6, 0]) cube([1, 1.2, cap_t]);
        }
    }
}

// roller surface: straight. Concave was tried on paper (2026-11-05) and dropped: rolling surfaces
// track toward the larger radius, as a belt climbs a crown, so a skewed spool would wander out.
function roll_r(z) = roll_od / 2 - waist * (1 - pow((z - roll_len / 2) / (roll_len / 2), 2));
module roller() {   // prints standing on end, no support; 2 x 608 in the end pockets
    difference() {
        rotate_extrude($fn = 64) polygon(concat([[0, 0]], [for (i = [0 : 40]) [roll_r(i * roll_len / 40), i * roll_len / 40]], [[0, roll_len]]));
        translate([0, 0, -1]) cylinder(d = 12, h = roll_len + 2, $fn = 32);
        for (z = [-0.01, roll_len - 7]) translate([0, 0, z]) cylinder(d = 22.15, h = 7.01, $fn = 64);
        translate([0, 0, 7]) cylinder(d1 = 21, d2 = 12, h = 4.5, $fn = 64);   // 45 deg roof over the bed-side pocket: no support
    }
}
module washer() difference() {   // on the bearing's inner race, against the plate
    cylinder(d = 12, h = washer, $fn = 48);
    translate([0, 0, -1]) cylinder(d = 8.3, h = washer + 2, $fn = 32);
}

module holder() {
    for (i = [0 : 2]) color([0.85, 0.92, 1.0]) translate([plate_x(i), 0, 0]) rotate([90, 0, 90]) linear_extrude(ta) plate2d(i != 1);
    for (y = strip_y) color([0.80, 0.88, 1.0]) translate([0, y + ta / 2, 0]) rotate([90, 0, 0]) linear_extrude(ta) strip2d();
    for (s = [-1, 1]) {
        color([0.55, 0.55, 0.58]) translate([-rod_in, s * roll_off, roll_z]) rotate([0, 90, 0]) cylinder(d = 8, h = rod_len, $fn = 32);
        if (show_caps) color([0.95, 0.55, 0.1]) {                             // end caps, both ends
            translate([-cap_off, s * roll_off, roll_z]) rotate([0, -90, 0]) cap();
            translate([W + cap_off, s * roll_off, roll_z]) rotate([0, 90, 0]) cap();
        }
        if (show_rollers) for (k = [0 : 1]) {
            x0 = plate_x(k) + ta;
            color("steelblue") translate([x0 + washer + float, s * roll_off, roll_z]) rotate([0, 90, 0]) roller();
            color([0.95, 0.55, 0.1]) for (wx = [x0, x0 + gap - washer]) translate([wx, s * roll_off, roll_z]) rotate([0, 90, 0])
                difference() { cylinder(d = 12, h = washer, $fn = 32); translate([0, 0, -1]) cylinder(d = 8.3, h = 3, $fn = 24); }
        }
    }
}

module spool(d = 210, w = 65, c = [0.95, 0.45, 0.35, 0.55]) {
    color(c) difference() { cylinder(d = d, h = w, center = true, $fn = 96); cylinder(d = 55, h = w + 2, center = true, $fn = 32); }
}

// in the box: inside width 628.4, 0.5 mm play at each wall; the right holder is the same
// part turned end for end (rotated 180 about z), so the two are identical
inner_w = 640 - 2 * 5.8;
module box_floor() {
    translate([wall_off, 0, 0]) { holder(); for (k = [0 : 1]) translate([slot_x(k), 0, spool_z(210)]) rotate([0, 90, 0]) spool(); }
    translate([inner_w - wall_off, 0, 0]) rotate([0, 0, 180]) { holder(); for (k = [0 : 1]) translate([slot_x(k), 0, spool_z(210)]) rotate([0, 90, 0]) spool(); }
    // spares: lying flat, stacked 3 high, centred between the holders
    mid = inner_w / 2;
    for (j = [0 : 2]) translate([mid, 0, 32.5 + j * 65.5]) spool(c = [0.85, 0.75, 0.55, 0.55]);
}

if (part == "holder") holder();
else if (part == "plate") plate2d();             // outer plate (print 4 per box)
else if (part == "plate_mid") plate2d(false);   // middle plate (2 per box)
else if (part == "strip") strip2d();
else if (part == "cap") cap();
else if (part == "roller") roller();
else if (part == "washer") washer();
else box_floor();

echo(str("holder width ", W, ", rod length ", rod_len, " (2 per 400 mm rod: ", 2 * rod_len, " + cut); roller ", roll_len,
         "; strips at y ", strip_y, " (roller edge ", roll_off + roll_od / 2, ")",
         "; feeder pair centre ", wall_off + ta + gap + ta / 2, " from the inside wall (feeders at ", 95.57 - 5.8,
         "); middle space ", inner_w - 2 * (wall_off + W + cap_off + cap_t)));
