// 2026-10-31: inside corner bracket for the dry box's 1010 front frame. A 90 degree angle
// in each inside corner of the door opening: one leg on the horizontal member's inner face,
// one on the vertical's inner face, 2 M3 screws per leg into T-nuts in those slots
// (the outer slots carry the panel screws, the front face carries the foam seal).
// Symmetric, so all 4 corners take the same part. The bracket is 0.5 mm narrower than the
// extrusion depth: set it flush with the back face so it stays clear of the door and seal.
// Print on its side (the L profile on the bed): layers then run around the corner, and the
// screw holes print horizontal (small, they bridge fine). PLA, 0.2 mm, 4 walls, 40 %.
// Profile axes: x along the horizontal leg, y along the vertical leg, z across the
// extrusion depth. Units mm.

ext     = 10;      // 1010 extrusion width and depth
// 2026-11-11: screws are now the M3 x 4 countersunk screws that come with the T-nuts (4 overall,
// head 6 x 90 deg): a counterbore from the exposed face down to csk_floor above the mounting
// face, a 90 deg countersink at its bottom, so the tip reaches 4 - csk_floor = 2.0 below the
// 1010 face (stop at 2.7). The leg keeps its full thickness around the holes.
// Head measured 5.7 across (2026-11-11).
csk_floor = 2.0;   // plastic under the head top: sets the reach
csk_d     = 5.9;   // countersink top diameter: the 5.7 head seats 0.1 below the counterbore floor (reach 2.1)
cb_d      = 6.0;   // counterbore: head and driver access
plate_t = 5.5;     // 2026-11-11: was 5.0. Measured: an M3 x 8 bottoms 2.7 below the 1010 face (5.3 showing),
                   // so 5.0 left the head 0.3 off the plate. 5.5: reaches 2.5 = tnut_tip in panels.scad
leg     = 36;      // leg length from the corner
w       = ext - 0.5;
screw_d = 3.5;     // M3 clearance
screw   = [15, 29];    // hole positions from the corner, both legs
fillet  = 6;       // inside fillet, kept clear of the nearest screw head (M3 head d 5.5)
edge_r  = 1;       // rounding on the leg ends and the outer corner
// alignment key: a rib down each leg's mounting face that drops into the slot opening
// (3.3 mm) and keeps the bracket centered and square. Tapered 3.0 -> 2.0 mm so it
// starts easily and its sideways overhang prints without support.
// 2026-11-11: KEY REMOVED (key_h = 0). Test fit: the rib reached past the slot lips and hit
// the T-nut, so the screw could not pull the nut up against the rail. Flat face now.
key_on  = false;
key_h   = key_on ? 1.0 : 0;
key_w   = [3.0, 2.0];  // at the face, at the tip
key_end = 1.5;         // stop short of the leg end and of the rounded outer corner

module profile() {
    offset(r = edge_r) offset(delta = -edge_r) union() {
        square([leg, plate_t]);
        square([plate_t, leg]);
    }
    translate([plate_t, plate_t]) difference() {
        square(fillet);
        translate([fillet, fillet]) circle(r = fillet, $fn = 48);
    }
}

// key along x on the y = 0 face, protruding toward -y
module key() {
    hull() {
        translate([key_end, -0.01, (w - key_w[0]) / 2]) cube([leg - 2 * key_end, 0.01, key_w[0]]);
        translate([key_end, -key_h, (w - key_w[1]) / 2]) cube([leg - 2 * key_end, 0.01, key_w[1]]);
    }
}

module csk_hole() {   // along +z from the mounting face (z = 0)
    translate([0, 0, -key_h - 1]) cylinder(d = screw_d, h = plate_t + key_h + 2, $fn = 24);
    translate([0, 0, csk_floor - (csk_d - screw_d) / 2]) cylinder(d1 = screw_d, d2 = csk_d, h = (csk_d - screw_d) / 2 + 0.01, $fn = 32);
    translate([0, 0, csk_floor]) cylinder(d = cb_d, h = plate_t, $fn = 32);
}

difference() {
    union() {
        linear_extrude(w) profile();
        if (key_on) {
            key();                                                 // horizontal leg
            multmatrix([[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]]) key();   // vertical leg (x <-> y)
        }
    }
    for (p = screw) {
        translate([p, 0, w / 2]) rotate([-90, 0, 0]) csk_hole();                                          // horizontal leg, axis +y
        multmatrix([[0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 1, 0]]) translate([p, 0, w / 2]) rotate([-90, 0, 0]) csk_hole();   // vertical leg
    }
}

echo(str("inside bracket ", leg, " x ", leg, " x ", w, " mm, plate ", plate_t,
         "; screws at ", screw, "; counterbore clear of the fillet by ",
         screw[0] - cb_d / 2 - (plate_t + fillet), " mm; side walls by the counterbore ", (w - cb_d) / 2,
         "; M3 x 4 csk (head 5.7) reach ", 4 - csk_floor + (csk_d - 5.7) / 2));
