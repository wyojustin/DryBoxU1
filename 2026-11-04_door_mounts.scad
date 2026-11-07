// 2026-11-04: door mounting, flipped: hooks at the top, swing-bolt latches at the bottom.
// 2026-11-05: installed the other way up (hinge at the bottom, latches on top): this file still
// draws hinge-on-top, and the assembly mirrors it (flip()). The parts themselves don't change.
// The door acrylic is a plain 640 x 258 rectangle with no holes; its outside 1010 frame is
// bonded on with VHB, and everything mounts to that frame with M3 T-nuts.
//  Top (x2, at 1/4 and 3/4 of the width): a printed J-hook on the door frame's top face hangs
//    over an 8 mm bar carried by a printed loop on the top panel's front edge; see below.
//  Bottom (x2): the swing-latch saddle (2026-11-03_swing_latch.scad, v4/v5) upside down under
//    the box's bottom front edge (screwed up through the bottom panel into the bottom 1010
//    member's bottom slot). Its M5 knob screw swings up into a U-slot in a printed catch on
//    the door frame's bottom face; tightening pulls the bottom edge in. Loosened, the screw
//    swings down and hangs. The box's front overhangs the bay by 41 mm, so the underside is
//    clear, and there is ~350 mm of open space below.
// Removing the door: loosen the 2 knobs, swing the screws down, tilt the bottom out, lift off.
// part = "assembly" | "hook" | "keeper" (the loop) | "bar_cap" | "catch" | "catch_print" | "knob" | "handle"; swing = 0 (latched) .. 90 (hanging).
// Box axes: y = 0 the shell's front face, z = 0 the box bottom. Units mm.

use <2026-11-03_swing_latch.scad>

part  = "assembly";
swing = 0;

X = 640; Z = 258; t = 5.8; ext = 10; foam = 2.1;
door_y0 = -foam - t;                 // door outer face (-7.9)
vhb     = 1.0;                       // 3M 4910 tape, 40 mil, between the door and its frame
df_y    = [door_y0 - vhb - ext, door_y0 - vhb];  // door frame, front to back (-18.9 .. -8.9)
df_mid  = (df_y[0] + df_y[1]) / 2;   // its slot line (-13.9)
mount_x = [X / 4, 3 * X / 4];

// ---------------- top: loop with bar + J-hook (Justin's sketch, 2026-11-04) ----------------
// The loop is a printed U on the top panel at the front edge, its 2 M3 screws down through the
// back wall and the top panel, behind the 1010 member, into washers and nylock nuts inside the
// box. It carries an 8 mm steel bar along x in a short y-slot. The bar is oily and slid out of
// a plain bore in the test print, so it is ONE bar from loop to loop (cut from a spare 400 rod:
// 320 between the loops + 47 + 2 x 6 = 379) with a large push-on end cap at each end, against
// the outer face of each loop (Justin, 2026-11-04).
// Top seal adjuster: per cheek, an M3 x 10 grub screw from the loop's front face (1.5 mm hex
// key) runs through a captured nut (dropped in from the top) and bears on the bar's front.
// Turning in pushes the bar back, which pulls the hooks and the door's top edge into the foam
// (0.5 mm per turn, 3 mm travel). Flush grubs, not knobs: a knob in front of the loop blocks the
// door frame as the door swings. The nut reacts forward against a 4 mm front wall.
// The hinge (was a 120 deg hook; Justin, 2026-11-05) sits on the door frame's top face and runs
// back over the door's top edge and the box's top front corner to a full ring around the bar, so
// the door swings on the bar and can't fall off it. The arm rests on the top panel and carries
// the door when closed; the back of the ring holds the top edge in. rise lifts the whole
// bar/ring system on a solid riser under the arm (3 and 8 tried; 0 since the riser needed
// support). The ring runs on the bar on 3 ribs (the fit of the end cap that spun with no gap),
// and a gusset ties it to the arm. Fitting: set the rings between the cheeks, slide the bar through, cap the
// ends; removing the door: pull one cap and slide the bar out. The gap between the cheeks is
// closed at the back (a 12 mm wall behind the ring's reach) for strength.
rise    = 0;                         // whole bar/hook system raised this far
lp      = [47, 38, 20 + rise];       // loop overall x, y (from y = 0), z (on the top panel)
ch_w    = 21;                        // gap between the cheeks, for the hook
slot_l  = 26;                        // the gap runs back to y = 26 (ring reaches 24.5 at full travel); solid behind
bar_d   = 8; bar_yz = [14.5, Z + 10 + rise];   // bar centre (mid travel): 14.5 behind the front face, 10 + rise above the box top
travel  = 3;                         // bar's y-slot travel
adj_x   = (ch_w / 2 + 47 / 2) / 2;   // adjusters on the cheeks' centre lines (17)
nut_af  = 5.36;                      // Justin's M3 nuts: 5.36 across flats, 2.15 thick
nut     = [nut_af + 0.3, 2.6]; nut_y = 4;   // pocket width, thickness; 4 mm front wall
grub_l  = 10;
bar_bore = 8.25;                     // printed horizontal: the rod slid in 8.25 on the gauge
hk_w    = 20; hk_t = 4;              // hook width, material thickness
ri      = 4.3;                       // ring bore radius: 8.6 bore with 3 ribs, tips at 8.1: the end cap that
ring_tip = 8.1;                      // spun on the rod with no visible gap (Justin, 2026-11-05)
cc      = [bar_yz[0] + bar_d / 2 - ring_tip / 2, bar_yz[1]];   // ring centre: the back rib on the back of the bar when closed
screw_xy = [[-15, 32], [15, 32]];    // loop screws, in the back wall (top panel holes to match)

back_r  = 6;                         // loop's back corners, top view
front_r = 6;                         // front top corner fillet, matching the back corners
module loop_side2d() difference() {   // in (y, z): front top corner rounded
    translate([0, Z]) square([lp[1], lp[2]]);
    difference() {
        translate([-1, Z + lp[2] - front_r]) square([front_r + 1, front_r + 1]);
        translate([front_r, Z + lp[2] - front_r]) circle(r = front_r, $fn = 64);
    }
}
module loop_top2d() hull() {   // in (x, y): back corners rounded
    translate([-lp[0] / 2, 0]) square([lp[0], 1]);
    for (m = [-1, 1]) translate([m * (lp[0] / 2 - back_r), lp[1] - back_r]) circle(r = back_r, $fn = 48);
}
module keeper() {   // the loop: a U (two cheeks joined at the back), printed base down; 2 x M3 x 16 + nylock, 2 x M3 nut + M3 x 10 grub; the bar slides in
    intersection() {
        difference() {
            translate([-lp[0] / 2, 0, Z]) cube(lp);
            translate([-ch_w / 2, -1, Z - 1]) cube([ch_w, slot_l + 1, lp[2] + 2]);          // gap for the hook, closed at the back
            translate([-lp[0] / 2 - 1, 0, 0]) rotate([90, 0, 90]) linear_extrude(lp[0] + 2) hull()
                for (dy = [-travel / 2, travel / 2]) translate(bar_yz + [dy, 0]) circle(d = bar_bore, $fn = 32);   // bar slot
            for (m = [-1, 1]) translate([m * adj_x, 0, bar_yz[1]]) {
                translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = bar_yz[0], $fn = 24);              // grub screw
                translate([-nut[0] / 2, nut_y, -nut_af / 2 / cos(30) - 0.1]) cube([nut[0], nut[1], lp[2]]);              // nut, dropped in
            }
            for (sxy = screw_xy) translate([sxy[0], sxy[1], Z - 1]) {
                cylinder(d = 3.4, h = lp[2] + 2, $fn = 24);
                translate([0, 0, 1 + 4]) cylinder(d = 6.2, h = lp[2], $fn = 32);
            }
        }
        translate([-lp[0] / 2 - 1, 0, 0]) rotate([90, 0, 90]) linear_extrude(lp[0] + 2) loop_side2d();
        translate([0, 0, Z - 1]) linear_extrude(lp[2] + 2) loop_top2d();
    }
}
bcap_d = 18; bcap_t = 7; bcap_in = 6;   // bar end cap: disc 18 x 7, 6 mm blind bore with crush ribs
bcap_bore = 8.6; bcap_rib = 0.4;         // ribs at 7.8 nominal, as the spool-holder caps
bar_x  = [mount_x[0] - lp[0] / 2 - bcap_in, mount_x[1] + lp[0] / 2 + bcap_in];   // bar ends (box x)
function bar_len() = bar_x[1] - bar_x[0];   // for the assembly's cut list
module bar_cap() {   // printed open end down, no supports
    difference() {
        union() {
            cylinder(d = bcap_d, h = bcap_t - 1, $fn = 64);
            translate([0, 0, bcap_t - 1]) cylinder(d1 = bcap_d, d2 = bcap_d - 2, h = 1, $fn = 64);
        }
        translate([0, 0, -1]) difference() {
            cylinder(d = bcap_bore, h = bcap_in + 1, $fn = 48);
            for (a = [0, 120, 240]) rotate(a) translate([bcap_bore / 2 - bcap_rib, -0.6, 0]) cube([1, 1.2, bcap_in + 1]);
        }
    }
}
module adjusters() for (m = [-1, 1]) color([0.15, 0.15, 0.17]) translate([m * adj_x, bar_yz[0] - bar_d / 2 - grub_l, bar_yz[1]])
    rotate([-90, 0, 0]) cylinder(d = 3, h = grub_l, $fn = 16);   // grub screws, at mid travel
module bar() {   // in box x: the one bar through both loops, with its two end caps
    color([0.55, 0.55, 0.58]) translate([bar_x[0], bar_yz[0], bar_yz[1]]) rotate([0, 90, 0])
        cylinder(d = bar_d, h = bar_x[1] - bar_x[0], $fn = 32);
    color([0.95, 0.55, 0.1]) {
        translate([mount_x[0] - lp[0] / 2, bar_yz[0], bar_yz[1]]) rotate([0, -90, 0]) bar_cap();
        translate([mount_x[1] + lp[0] / 2, bar_yz[0], bar_yz[1]]) rotate([0, 90, 0]) bar_cap();
    }
}

module hook_profile() {   // in (y, z): riser, arm under the bar, full ring around it
    ro = ri + hk_t;
    if (rise > 0) translate([df_y[0], Z]) square([-foam - df_y[0], rise]);           // riser on the door frame and door top edge
    translate([df_y[0], Z + rise]) square([cc[0] - df_y[0], hk_t]);   // arm (top face under the bar)
    difference() {
        hull() {                                                          // ring, with a gusset down to the arm
            translate(cc) circle(r = ro, $fn = 96);
            translate([cc[0] - 14, Z + rise]) square([14, hk_t]);
        }
        translate(cc) difference() {
            circle(r = ri, $fn = 96);
            for (a = [0, 120, 240]) rotate(a) translate([ring_tip / 2, -0.6]) square([1, 1.2]);   // running ribs, one at the back
        }
    }
}
module hook() {   // printed on its side; 2 x M3 down into the door frame's top slot
    difference() {
        translate([-hk_w / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(hk_w) hook_profile();
        for (m = [-1, 1]) translate([m * 6, df_mid, Z - 1]) {
            cylinder(d = 3.4, h = 20, $fn = 24);
            translate([0, 0, 1 + 2]) cylinder(d = 6.2, h = 20, $fn = 32);
        }
    }
}

// ---------------- bottom: saddle (upside down) + catch ----------------
// the saddle file works in top-of-box coordinates (box top Z, pivot 272); flip it about the
// mid-plane between z = Z and z = 0 so it hangs under the bottom panel
module under(lx) translate([lx, 0, 0]) mirror([0, 0, 1]) translate([0, 0, -Z]) children();
piv_y = 12; piv_z = -(272 - Z);       // pivot under the box: y 12, z -14
ct      = [30, ext, 22];              // catch x, y (= door frame depth), z (stands off the frame)
ct_leg  = 3;                          // leg down the frame's outer face: the knob bears on it
ct_r    = 4;                          // free corner rounded
slot_w  = 5.6;
module catch_side2d() difference() {   // in (y, z): block on the frame's end face, leg wrapped round its outer face
    translate([df_y[0] - ct_leg, -ct[2]]) square([ext + ct_leg, ct[2] + ext]);
    translate([df_y[0], 0]) square([ext + 1, ext + 1]);                                 // the frame member
    difference() {                                                                   // free corner
        translate([df_y[0] - ct_leg - 1, -ct[2] - 1]) square([ct_r + 1, ct_r + 1]);
        translate([df_y[0] - ct_leg + ct_r, -ct[2] + ct_r]) circle(r = ct_r, $fn = 48);
    }
}
module catch_part() {   // printed knob face down (catch_print), so the U-slot is vertical. The knob's pull tips the catch
    difference() {      // over the frame's inner edge; the leg's 2 M3, the only screws, hold it down in shear, into the
        translate([-ct[0] / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(ct[0]) catch_side2d();   // frame's outer slot
        hull() {   // U-slot open away from the frame, round end on the screw axis
            translate([0, df_y[0] - ct_leg - 1, piv_z]) rotate([-90, 0, 0]) cylinder(d = slot_w, h = ext + ct_leg + 2, $fn = 32);
            translate([-slot_w / 2, df_y[0] - ct_leg - 1, -ct[2] - 1]) cube([slot_w, ext + ct_leg + 2, 0.01]);
        }
        for (m = [-1, 1]) translate([m * 10, df_y[0] - ct_leg - 1, ext / 2]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = ct_leg + 2, $fn = 24);   // 2 M3 in the leg
    }
}
kb_floor = 3;                         // knob plastic under the screw head; thin so an M5 x 35 reaches the barrel
kb_seat  = 8.6; kb_rib = 0.25;        // M5 socket head (8.5 knurled): round pocket, 3 crush ribs grip it
bolt_l   = 35;
module knob2() {   // stand-in for Justin's bought M5 x 35 knobs (35 of thread under the face); also printable with an M5 x 35 socket-head screw
    rotate([90, 0, 0]) difference() {
        union() {
            cylinder(d = 22, h = 10, $fn = 48);
            for (a = [0, 180]) rotate(a) translate([0, -2.5, 0]) cube([15, 5, 10]);
        }
        translate([0, 0, -1]) cylinder(d = 5.5, h = 20, $fn = 24);
        translate([0, 0, kb_floor]) difference() {
            cylinder(d = kb_seat, h = 10, $fn = 48);
            for (a = [0, 120, 240]) rotate(a) translate([kb_seat / 2 - kb_rib, -0.6, 0]) cube([1, 1.2, 10]);
        }
    }
}
module bottom_latch(lx, sw = 0) {
    color([0.95, 0.55, 0.1]) under(lx) saddle();
    translate([lx, piv_y, piv_z]) rotate([sw, 0, 0]) translate([0, -piv_y, -piv_z]) {   // swings down
        color([0.72, 0.72, 0.75]) translate([-10, piv_y, piv_z]) rotate([0, 90, 0]) cylinder(d = 10, h = 20, $fn = 48);
        color("silver") translate([0, df_y[0] - ct_leg + bolt_l, piv_z]) rotate([90, 0, 0]) cylinder(d = 5, h = bolt_l, $fn = 24);
        color([0.15, 0.15, 0.17]) translate([0, df_y[0] - ct_leg, piv_z]) knob2();
    }
}

// ---------------- handle ----------------
// a printed D-pull on the outer face of the door frame's latch-side member, 2 M3 into the outer
// slot. Printed flat (this profile on the bed). Drawn on the frame's bottom member, like the
// catches; flip() in the assembly puts it at the top of the door.
hd      = [110, 30, ext];             // handle x, out from the frame, z (= member height)
hd_bar  = 9; hd_foot = 16;            // grip thickness, foot width
module handle2d() difference() {      // in (x, y): y = 0 on the frame's outer face, grip at -hd[1]
    offset(r = 4, $fn = 32) offset(delta = -4) translate([-hd[0] / 2, -hd[1]]) square([hd[0], hd[1] + 6]);
    offset(r = 5, $fn = 32) offset(delta = -5) translate([-hd[0] / 2 + hd_foot, -hd[1] + hd_bar]) square([hd[0] - 2 * hd_foot, hd[1] - hd_bar + 8]);
    translate([-hd[0], 0]) square([2 * hd[0], 10]);
}
module handle() {
    translate([0, df_y[0], 0]) difference() {
        linear_extrude(hd[2]) handle2d();
        for (m = [-1, 1]) translate([m * (hd[0] / 2 - hd_foot / 2), 1, ext / 2]) rotate([90, 0, 0]) {
            cylinder(d = 3.4, h = hd[1] + 2, $fn = 24);
            translate([0, 0, 5]) cylinder(d = 6.2, h = hd[1], $fn = 32);                 // head counterbore, 4 mm floor
        }
    }
}

// ---------------- context and assembly ----------------
module context() {
    color([0.80, 0.88, 1.0, 0.5]) { translate([0, 0, Z - t]) cube([X, 70, t]); cube([X, 70, t]); }
    color([0.75, 0.76, 0.78]) { translate([t, 0, Z - t - ext]) cube([X - 2 * t, ext, ext]); translate([t, 0, t]) cube([X - 2 * t, ext, ext]); }
    color([0.85, 0.92, 1.0, 0.6]) translate([0, door_y0, 0]) cube([X, t, Z]);
    color([0.70, 0.71, 0.73]) translate([0, df_y[0], 0]) difference() {
        cube([X, ext, Z]); translate([ext, -1, ext]) cube([X - 2 * ext, ext + 2, Z - 2 * ext]);
    }
}
module door_mounts(sw = 0) {
    bar();
    for (lx = mount_x) {
        translate([lx, 0, 0]) { color([0.95, 0.55, 0.1]) keeper(); adjusters(); color([0.2, 0.2, 0.22]) hook(); }
        color([0.2, 0.2, 0.22]) translate([lx, 0, 0]) catch_part();
        bottom_latch(lx, sw);
    }
}

if (part == "hook") hook();
else if (part == "keeper") keeper();
else if (part == "bar_cap") bar_cap();
else if (part == "catch") catch_part();
else if (part == "catch_print") translate([0, 0, ct_leg - df_y[0]]) rotate([90, 0, 0]) catch_part();   // as printed: knob face on the bed, U-slot vertical
else if (part == "knob") knob2();
else if (part == "handle") translate([0, -df_y[0], 0]) handle();
else { context(); door_mounts(swing); }

echo(str("bar centre y ", bar_yz[0], " z ", bar_yz[1], "; curve centre (closed) ", cc, ", inside r ", ri,
         " (play ", 2 * ri - bar_d, " until closed); ring top ", cc[1] + ri + hk_t, "; loop top ", Z + lp[2]));
