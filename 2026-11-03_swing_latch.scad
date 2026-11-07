// 2026-11-03: swing-bolt door latch (Justin's design), 2 per door on the top edge at 1/4 and
// 3/4 of the width. On top of the box at its front edge, a one-piece printed saddle cradles
// a steel M5 barrel nut (cross dowel, 10 x 20) as the pivot (axis along x). An M5 knob screw
// threads into it and lies forward in a round-bottomed U-slot in the door's top edge (the
// door stands 10 mm above the box for this). Tightening pulls the door into the foam; a few
// turns loose, the screw and knob swing up out of the slot and the door is free.
// v2 (sturdier): the twin hooks became one 47 x 20 x 10 saddle; the pull goes from the
// barrel's full 20 mm length into a 5.8 mm front wall, then through 4 M3 screws (counterbored)
// into T-nuts in the top 1010 member's top slot.
// v3 (2026-11-04, box now stands 41 mm proud of the bay, so the latch is clear of the shelf
// rail and the 2020 drawer face): saddle raised 6 mm (solid base under the barrel, pivot at
// 269, top at 274; door extension to 274), and a groove along the saddle's back so the screw
// can flip all the way back and rest there with the knob on the top panel.
// v4 (2026-11-04): the screw's threaded tail, past the barrel, sweeps a circle around the pivot
// as the knob swings; a cylindrical pocket (radius tail_r, as wide as the screw slot) around
// the pivot lets it go all the way round without catching. The saddle is deeper (28 front to
// back) and taller (pivot at 272, top at 277) to hold that pocket; door extension to 277.
// v5 (2026-11-04): used upside down under the box's bottom front edge (see
// 2026-11-04_door_mounts.scad); the barrel's mouth is now a 9.4 snap so it can't fall out.
// v6 (2026-11-05): printed barrel in place of the steel cross dowel: 20 long, a plain M5
// nut (8 AF x 4.8) drops into a slot from one end and self-centres on the hex-shaped slot bottom;
// the pull goes nut -> barrel wall -> the saddle's bore, along the barrel's length. The saddle
// is unchanged. Print standing, open end up.
// v9 (2026-11-05): 1010 T-nuts are 9.3 long, too long for the 6.4 spacing at y = 5, so the screws
// move behind the barrel, clear of the 1010, into nylocks like the door loop. That also puts
// them on the side that resists the knob's pull: a 16 mm lever from the saddle's front edge, not 4.
// v8 (2026-11-05): the back shortened so the saddle is symmetric about the barrel (22 deep).
// v7 (2026-11-05): the 10 mm printed barrel broke going in (0.2 mm walls beside the nut), so the
// barrel is 12 across: 1.3 mm walls, 3.4 behind the nut. Saddle bore, mouth and height follow
// cyl_d. The saddle's corners are rounded to match the door loop (r 6: back corners in plan, front
// edge of the free face). Steel fallback: M6 x 20 cross dowel (10 across; M5 ones are 8) with
// cyl_d = 10, M6 knobs and the catch's U-slot widened to 6.6.
// part = "assembly" | "saddle" | "barrel" | "knob"; swing = 0 (latched) .. 180 (flipped back, resting).
// Box axes: y = 0 the shell's front face, z = 0 the box bottom. Units mm.

part  = "assembly";
swing = 0;

Z = 258; t = 5.8; ext = 10; foam = 2.1;
door_y0 = -foam - t;               // door outer face
dframe  = ext;                     // outside 1010 door frame
cyl_d   = 12;  cyl_len = 20;      // printed barrel with an M5 nut
cyl_y   = 12;                      // pivot axis, behind the front edge
tail_r  = 10;                      // v4: swept radius of the screw's tail; v8: 10, with the shorter back
floor_t = 4;                       // saddle floor under that pocket (with tail_r, pivot stays at 272)
pivot_z = Z + floor_t + tail_r;    // 272
sad_y0  = 1;                       // saddle front edge, just behind the shell's front face
sad     = [47, 2 * (cyl_y - sad_y0), pivot_z + cyl_d / 2 - Z];   // saddle x, y (v8: symmetric about the barrel), z
screw_xy = [[-15, 17], [15, 17]];  // v9: 2 M3 x 16 behind the barrel, through the top panel into nylocks
mouth_w = cyl_d - 0.4;             // v5: snap-in mouth, under the barrel, so it stays put upside down
sad_r   = 6;                       // v7: rounded corners, as the door loop
door_top = pivot_z + 5;            // door extension top, 277
slot_w   = 5.6;

// U-slot in the door's top edge, in (x, z): round bottom centered on the pivot height
module u_slot() {
    hull() {
        translate([0, pivot_z]) circle(d = slot_w, $fn = 32);
        translate([-slot_w / 2, pivot_z + 20]) square([slot_w, 0.01]);
    }
}

// one-piece saddle: bore for the barrel (drop-in mouth on top, front wall kept), centre slot
// for the screw to lie forward and swing up, rest groove behind, 4 counterbored M3 holes
// (M3 x 12: 4 mm saddle floor + 5.8 acrylic + T-nut)
module saddle() {
    intersection() {
        difference() {
            translate([-sad[0] / 2, sad_y0, Z]) cube(sad);
            translate([-cyl_len / 2 - 0.3, cyl_y, pivot_z]) rotate([0, 90, 0]) cylinder(d = cyl_d + 0.4, h = cyl_len + 0.6, $fn = 48);
            translate([-cyl_len / 2 - 0.3, cyl_y - mouth_w / 2, pivot_z]) cube([cyl_len + 0.6, mouth_w, 20]);   // snap-in mouth
            translate([-3.2, sad_y0 - 1, pivot_z - 3.2]) cube([6.4, cyl_y - sad_y0 + 1, 20]);                              // screw slot
            translate([-3.2, cyl_y, pivot_z - 2.8]) cube([6.4, sad_y0 + sad[1] - cyl_y + 1, 20]);                          // v3: rest groove at the back
            translate([-3.2, cyl_y, pivot_z]) rotate([0, 90, 0]) cylinder(r = tail_r, h = 6.4, $fn = 64);                // v4: tail pocket
            for (sxy = screw_xy) translate([sxy[0], sxy[1], Z - 1]) {
                cylinder(d = 3.4, h = sad[2] + 2, $fn = 24);
                translate([0, 0, 4]) cylinder(d = 6.2, h = sad[2], $fn = 32);                                         // head counterbore
            }
        }
        translate([-sad[0] / 2 - 1, 0, 0]) rotate([90, 0, 90]) linear_extrude(sad[0] + 2) difference() {   // v7: free face's front edge
            translate([sad_y0, Z]) square([sad[1], sad[2]]);
            difference() {
                translate([sad_y0 - 1, Z + sad[2] - sad_r]) square([sad_r + 1, sad_r + 1]);
                translate([sad_y0 + sad_r, Z + sad[2] - sad_r]) circle(r = sad_r, $fn = 64);
            }
        }
        translate([0, 0, Z - 1]) linear_extrude(sad[2] + 2) hull() {                                   // v7: back corners
            translate([-sad[0] / 2, sad_y0]) square([sad[0], 1]);
            for (m = [-1, 1]) translate([m * (sad[0] / 2 - sad_r), sad_y0 + sad[1] - sad_r]) circle(r = sad_r, $fn = 48);
        }
    }
}

module barrel() {   // axis z, as printed; screw hole along y; slot open at the top
    af = 8.2; th = 5.1;   // Justin's M5 nuts are 4.8 thick
    difference() {
        translate([0, 0, -cyl_len / 2]) cylinder(d = cyl_d, h = cyl_len, $fn = 64);
        rotate([90, 0, 0]) cylinder(d = 5.5, h = cyl_d + 2, center = true, $fn = 32);
        rotate([90, 0, 0]) translate([0, 0, -th / 2]) linear_extrude(th) hull() {
            rotate(30) circle(d = af / cos(30), $fn = 6);
            translate([-af / 2, 0]) square([af, cyl_len]);
        }
    }
}
module cyl() {   // steel barrel nut, for the picture
    difference() {
        translate([-cyl_len / 2, cyl_y, pivot_z]) rotate([0, 90, 0]) cylinder(d = cyl_d, h = cyl_len, $fn = 48);
        translate([0, cyl_y + 6, pivot_z]) rotate([90, 0, 0]) cylinder(d = 5, h = 12, $fn = 24);
    }
}

module knob() {   // grip in front of the door frame, a neck reaching back to bear on the door
    neck_l = dframe + 1;
    rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d = 9, h = neck_l, $fn = 32);                         // neck on the door face
            translate([0, 0, neck_l]) cylinder(d = 22, h = 10, $fn = 48);  // grip
            for (a = [0, 180]) rotate(a) translate([0, -2.5, neck_l]) cube([15, 5, 10]);
        }
        translate([0, 0, -1]) cylinder(d = 5.5, h = 40, $fn = 24);
        translate([0, 0, neck_l + 6]) cylinder(d = 8.6 / cos(30), h = 5, $fn = 6);   // M5 head
    }
}

module latch(lx) {
    translate([lx, 0, 0]) {
        color([0.95, 0.55, 0.1]) saddle();
        // swinging set: cylinder, screw, knob rotate about the pivot axis
        translate([0, cyl_y, pivot_z]) rotate([-swing, 0, 0]) translate([0, -cyl_y, -pivot_z]) {
            color([0.72, 0.72, 0.75]) cyl();
            color("silver") translate([0, cyl_y + 2, pivot_z]) rotate([90, 0, 0]) cylinder(d = 5, h = cyl_y + 2 - door_y0 + dframe + 8, $fn = 24);
            color([0.15, 0.15, 0.17]) translate([0, door_y0, pivot_z]) knob();
        }
    }
}

// context: top panel edge, top frame member, door with its slotted extension, door frame
module context(lxs) {
    color([0.80, 0.88, 1.0, 0.5]) translate([0, 0, Z - t]) cube([640, 60, t]);
    color([0.75, 0.76, 0.78]) translate([t, 0, Z - t - ext]) cube([640 - 2 * t, ext, ext]);
    color([0.85, 0.92, 1.0, 0.6]) difference() {
        translate([0, door_y0, Z - 70]) cube([640, t, door_top - (Z - 70)]);
        for (lx = lxs) translate([lx, door_y0 - 1, 0]) rotate([-90, 0, 0])
            linear_extrude(t + 2) mirror([0, 1, 0]) u_slot();
    }
    color([0.70, 0.71, 0.73]) translate([0, door_y0 - dframe, Z - ext]) cube([640, dframe, ext]);
}

if (part == "saddle") saddle();
else if (part == "barrel") barrel();
else if (part == "knob") knob();
else { context([640 / 4]); latch(640 / 4); }
