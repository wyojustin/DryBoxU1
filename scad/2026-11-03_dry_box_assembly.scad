// 2026-11-03: full dry box mock-up for viewing (open in OpenSCAD, F5, zoom around).
// Acrylic shell from the panels file, 1010 front frame with the 4 inside corner brackets,
// foam door seal, door (open or closed) hung on top hooks and pulled in by bottom swing-bolt latches,
// 2 laser-cut 2-spool holders (one per side wall) with the desiccant drawer and spares between
// them, the 2 U1 feeders on their inserts with outlet seals, tubes, case screws and ribbon
// cables, and a floor desiccant drawer in a tunnel under a perforated deck.
// Placeholders: feeder bodies (blocks, depth 55 guessed), tray, spools.
// Toggles below. Units mm; x = width, y = depth (y = 0 is the shell's front edge), z = up.

use <2026-10-30_dry_box_panels.scad>
use <2026-11-04_spool_holder.scad>
use <2026-11-05_interior.scad>
use <2026-11-03_swing_latch.scad>
use <2026-11-04_door_mounts.scad>

show_top     = true;    // false: lift the lid off to see inside
show_bay     = true;    // the cart's 2020 frame at the bay's front (dimensions from Justin's notes)
door_angle   = 160;       // door swung down on the bar, degrees: 0 closed, 90 level, 162 resting on the loops
show_door    = true;
show_spools  = true;
acrylic_alpha = 0.30;

t = 5.8; X = 640; Z = 258; Y = 430;   // shell, as in the panels file
ext   = 10;
foam  = 2.1;
pitch = (X - 2 * t) / 7;
top_in  = Z - t;
back_in = Y - t;

// spool holders (holder file geometry: x from the holder's outer plate face, y = 0 on the
// spool axes, z from the floor). No floor rail (dropped 2026-11-11, Justin: unnecessary); the
// holders just sit on the floor, plates 23 .. 207 deep.
ta = 5.8; gap = 82; cap_t = 4; roll_off = 65; roll_z = 20; roll_od = 28;
hW = 3 * ta + 2 * gap;                 // holder width (181.4)
spool_y  = 115;                        // spool axis depth
function axis_z(d) = roll_z + sqrt(pow(d / 2 + roll_od / 2, 2) - pow(roll_off, 2));
function slot_x(k) = ta + gap / 2 + k * (ta + gap);
spool_d = 210; spool_w = 65;
hold_x  = [t + holder_wall_off(), X - t - holder_wall_off()];   // left holder origin; right holder origin (turned 180)
fed_x   = [hold_x[0] + slot_x(0), hold_x[0] + slot_x(1), hold_x[1] - slot_x(1), hold_x[1] - slot_x(0)];

// feeders
hang_x = [t + pitch, X - t - pitch];
hang_y = back_in - foam + 0.2 - 33;    // insert center, as in the panels file
fd     = [58.4, 61.8, 55];
black_l = 26;
face_y = back_in - foam;
port_z = top_in - 40;
case_z = top_in - 30;

module acrylic(c) { color([c[0], c[1], c[2], acrylic_alpha]) children(); }

// ---------------- opaque parts first (OpenCSG draws in order) ----------------

// 1010 frame
color([0.75, 0.76, 0.78]) frame3d();

// inside corner brackets: profile x along the horizontal member, profile y along the
// vertical, extrusion across the frame depth; mirrored into all 4 corners
for (mx = [0, 1], mz = [0, 1])
    translate([X / 2, 0, Z / 2]) mirror([mx, 0, 0]) mirror([0, 0, mz]) translate([-X / 2, 0, -Z / 2])
        color([0.2, 0.2, 0.22]) translate([t + ext, 0.5, t + ext])
            multmatrix([[1, 0, 0, 0], [0, 0, 1, 0], [0, 1, 0, 0]])
                import("../stl/corner_bracket_qty=4.stl");

// foam seal on the frame face, centered over the frame / acrylic seam
color([0.25, 0.25, 0.25]) translate([0, -foam, 0]) rotate([90, 0, 0]) mirror([0, 0, 1])
    linear_extrude(foam) difference() {
        translate([1.5, 1.5]) square([X - 3, Z - 3]);
        translate([1.5 + 12.7, 1.5 + 12.7]) square([X - 3 - 25.4, Z - 3 - 25.4]);
    }

// spool holders, spinning spools, and the spares stacked flat in the middle
for (k = [0 : 1]) translate([hold_x[k], spool_y, t]) rotate([0, 0, k * 180]) {
    holder();
    if (show_spools) for (j = [0 : 1]) color("tomato") translate([slot_x(j), 0, axis_z(spool_d)]) rotate([0, 90, 0])
        difference() { cylinder(d = spool_d, h = spool_w, center = true, $fn = 96); cylinder(d = 55, h = spool_w + 2, center = true, $fn = 48); }
}
// desiccant drawer on the floor, centred, pushed to the back wall: a plain open tray in a
// self-contained acrylic tunnel (floor sheet, 2 walls, perforated deck; nothing bonded to the box,
// no top mounts). The floor sheet raises the tray 5.8 and the air gap above it lets it lift the
// other 4.2 over the front frame member on the way out. The deck carries the
// spares, 2 stacks of 2, flat.
dr      = int_dr(); dr_air = int_air();                 // tray x, y, z; air gap above it
tn      = int_tun();
dr_x0   = X / 2 - dr[0] / 2; dr_y0 = back_in - 4 - dr[1];
tun_in  = tn[0];                                        // between the tunnel walls
tun_x   = [X / 2 - tun_in / 2 - t, X / 2 + tun_in / 2]; // the walls' left faces
deck_z  = 2 * t + dr[2] + dr_air;                       // deck's underside
// the tray is now a bought pan (2026-11-07): Elite Global Solutions SS6152, 15 x 6 x 2 in body,
// wire end handles. ASSUMED until it arrives: body 381 x 152 x 51, 1 mm wall, handles stand 12.7
// off the ends (from photos), loop 114 wide, 5 mm rod, lower wire 10 above the bottom.
// Back handle 4 off the back wall.
pan     = [152.4, 381, 50.8]; pan_wall = 1.0;
pan_hdl = [114, 12.7, 5, 10, 40];     // loop width, stand-off, rod d, lower and upper wire z
pan_y0  = back_in - 4 - pan_hdl[1] - pan[1];
module pan_handle() {                 // in the end face's plane at y = 0, sticking out toward -y
    w = pan_hdl[0]; so = pan_hdl[1]; d = pan_hdl[2]; z0 = pan_hdl[3]; z1 = pan_hdl[4];
    y = -so + d / 2;
    for (z = [z0, z1]) hull() for (s = [-1, 1]) translate([s * (w / 2 - d), y, z]) sphere(d = d, $fn = 16);
    for (s = [-1, 1]) {
        hull() for (z = [z0, z1]) translate([s * (w / 2 - d), y, z]) sphere(d = d, $fn = 16);
        translate([s * (w / 2 - d), 0, z1]) rotate([90, 0, 0]) cylinder(d = d, h = -y, $fn = 16);   // stand-off at the top
    }
}
color([0.78, 0.79, 0.81]) translate([X / 2, pan_y0, 2 * t]) {
    translate([-pan[0] / 2, 0, 0]) difference() {
        cube(pan);
        translate([pan_wall, pan_wall, pan_wall]) cube(pan - [2 * pan_wall, 2 * pan_wall, 0] + [0, 0, 1]);
    }
    pan_handle();
    translate([0, pan[1], 0]) mirror([0, 1, 0]) pan_handle();
}
acrylic([0.80, 0.88, 1.0]) translate([tun_x[0], ext + 0.5, t]) cube([tun_x[1] + t - tun_x[0], back_in - ext - 0.5, t]);
acrylic([0.80, 0.88, 1.0]) for (x = tun_x) translate([x, ext + 0.5, 2 * t]) rotate([90, 0, 90]) linear_extrude(t) wall2d();
acrylic([0.85, 0.92, 1.0]) translate([tun_x[0], 1, deck_z]) linear_extrude(t) deck2d();
stack_y = [back_in - 1 - spool_d / 2, back_in - 1 - spool_d * 3 / 2 - 1];
if (show_spools) for (y = stack_y, j = [0 : 1]) color("burlywood") translate([X / 2, y, deck_z + t + spool_w / 2 + j * (spool_w + 0.5)])
    difference() { cylinder(d = spool_d, h = spool_w, center = true, $fn = 96); cylinder(d = 55, h = spool_w + 2, center = true, $fn = 48); }

// deep storage: 1 spare flat on the floor behind each roller pair, against the back wall, tucked
// under the spinning spools' rear curve; goes in over the deck with the deck spares out
store_x = [(t + tun_x[0]) / 2, (tun_x[1] + t + X - t) / 2];
if (show_spools) for (x = store_x) color("burlywood") translate([x, stack_y[0], t + spool_w / 2])
    difference() { cylinder(d = spool_d, h = spool_w, center = true, $fn = 96); cylinder(d = 55, h = spool_w + 2, center = true, $fn = 48); }

echo(str("drawer ", dr, " y ", dr_y0, " .. ", dr_y0 + dr[1], "; tunnel outer x ", tun_x[0], " .. ", tun_x[1] + t,
         "; deck top z ", deck_z + t, "; stack top z ", deck_z + t + 2 * spool_w + 0.5, " (top inside ", top_in, "); front stack front y ", stack_y[1] - spool_d / 2,
         "; holders end x ", hold_x[0] + hW + holder_wall_off() - 1,   // outer plate + cap stand-off + cap
         "; storage gap ", tun_x[0] - t, ", front y ", stack_y[0] - spool_d / 2,
         ", spinning spool rear at its top ", spool_y + sqrt(pow(spool_d / 2, 2) - pow(t + axis_z(spool_d) - t - spool_w, 2))));

// feeders, inserts, seals, tubes, screws, ribbons
for (k = [0 : 1]) {
    fx = hang_x[k];
    color([0.95, 0.55, 0.1]) translate([fx, hang_y, top_in]) rotate([0, 0, 180])
        import("../stl/feeder_insert_qty=2.stl");
    translate([fx, face_y, top_in]) {
        color([0.15, 0.15, 0.17]) translate([-fd[0] / 2, -black_l, -fd[2]]) cube([fd[0], black_l, fd[2]]);
        color("white") translate([-fd[0] / 2, -fd[1], -fd[2]]) cube([fd[0], fd[1] - black_l, fd[2]]);
        for (s = [-1, 1]) color("black") translate([s * 13, 0, -40]) rotate([-90, 0, 0])
            cylinder(d = 10, h = 1.5, $fn = 32);
    }
    color([0.3, 0.3, 0.3]) translate([fx, face_y, port_z]) rotate([-90, 0, 0]) linear_extrude(foam)
        difference() {
            offset(r = 6) square([42, 16], center = true);
            offset(r = 8) square([26, 0.01], center = true);
        }
    color([0.6, 0.6, 0.65]) translate([fx - 9.5, back_in - 4.5, top_in - 2]) cube([19, 1, 30]);
    for (j = [0 : 1]) {
        s = 2 * j - 1;
        sx = fed_x[2 * k + j];
        color("red") hull() {                                   // filament, spool to inlet
            translate([sx, spool_y + 20, t + axis_z(spool_d) + spool_d / 2 - 2]) sphere(d = 1.75, $fn = 8);
            translate([fx + s * 13, face_y - fd[1], port_z]) sphere(d = 1.75, $fn = 8);
        }
        color([0.92, 0.96, 1.0]) {                              // PTFE out the back, up to the printer
            translate([fx + s * 13, face_y, port_z]) rotate([-90, 0, 0]) cylinder(d = 4.1, h = 30, $fn = 16);
            translate([fx + s * 13, face_y + 30, port_z]) cylinder(d = 4.1, h = 120, $fn = 16);
        }
        color("silver") translate([fx + s * 46.9 / 2, Y, case_z]) rotate([90, 0, 0]) {
            translate([0, 0, -2]) cylinder(d = 5.6, h = 2, $fn = 24);
            cylinder(d = 2.8, h = 44, $fn = 12);
        }
    }
}

// ---------------- transparent acrylic last ----------------
acrylic([0.80, 0.88, 1.0]) for (p = ["bottom", "back", "left", "right"]) render() panel3d(p);
if (show_top) acrylic([0.80, 0.88, 1.0]) render() panel3d("top");
// heater cord hole, plugged, on the back panel
color([0.2, 0.2, 0.22]) translate([cord_hole()[1][0], Y + 2, cord_hole()[1][1]]) rotate([90, 0, 0]) cord_plug();

// cart bay, front only: 2020 rails under and over the box, posts either side. The box sits on the
// lower rail, front 41 proud of it; 648 wide (measured), 270 clear between the rails. Back rail y 411 .. 431.
bay_y = 41; bay_w = 648; bay_h = 270; bx = 20;
if (show_bay) color([0.35, 0.36, 0.40]) {
    for (z = [-bx, bay_h]) translate([(X - bay_w) / 2 - bx, bay_y, z]) cube([bay_w + 2 * bx, bx, bx]);
    translate([(X - bay_w) / 2 - bx, 411, -bx]) cube([bay_w + 2 * bx, bx, bx]);
    for (x = [(X - bay_w) / 2 - bx, (X + bay_w) / 2]) translate([x, bay_y, -bx - 330]) cube([bx, bx, bay_h + 2 * bx + 330]);
}

// door mounting (2026-11-04_door_mounts.scad), flipped (Justin, 2026-11-05): hinge (loops, bar,
// rings) under the bottom front edge, swing-bolt latches (saddles) on top, catches on the door
// frame's top face, at 1/4 and 3/4 of the width. The door mounts file draws them the other way
// up, so all of it goes through flip(), a mirror about the box's mid-height.
// door_angle > 0: latches loosened, the door's top swung out and down about the bar.
module flip() translate([0, 0, Z]) mirror([0, 0, 1]) children();
mount_x = [X / 4, 3 * X / 4];
flip() bar();
for (lx = mount_x) flip() {
    translate([lx, 0, 0]) { color([0.95, 0.55, 0.1]) keeper(); adjusters(); }
    bottom_latch(lx, door_angle > 0 ? 90 : 0);
}
bar_pivot = [14.5, Z + 10];            // the bar's centre (door mounts file)
module door_swing() translate([0, bar_pivot[0], bar_pivot[1]]) rotate([-door_angle, 0, 0]) translate([0, -bar_pivot[0], -bar_pivot[1]]) children();
if (show_door) flip() door_swing() {
    color([0.70, 0.71, 0.73]) translate([0, -foam - t - 1 - ext, 0]) difference() {   // outside 1010 frame, on 1 mm VHB
        cube([X, ext, Z]);
        translate([ext, -1, ext]) cube([X - 2 * ext, ext + 2, Z - 2 * ext]);
    }
    for (lx = mount_x) translate([lx, 0, 0]) color([0.2, 0.2, 0.22]) { hook(); catch_part(); }
    color([0.2, 0.2, 0.22]) translate([X / 2, 0, 0]) handle();
    // VHB, 12.7 wide and left untrimmed: flush with the frame's outer edge, 2.7 showing inside it
    color([0.6, 0.6, 0.62]) translate([0, -foam - t, 0]) rotate([90, 0, 0]) linear_extrude(1) difference() {
        square([X, Z]);
        translate([12.7, 12.7]) square([X - 25.4, Z - 25.4]);
    }
}
if (show_door) acrylic([0.85, 0.92, 1.0]) flip() door_swing() translate([0, -foam, 0]) rotate([90, 0, 0])
    linear_extrude(t) square([X, Z]);                      // plain door panel

// ---------------- cut list ----------------
// Every length comes from the values that draw the model, so the list can't disagree with it.
// Hardware isn't here: echo only knows what's modeled, so that list is checked by hand.
// Save it with:  openscad -o /tmp/x.echo 2026-11-03_dry_box_assembly.scad
sd = shell_dims();
assert(sd[0] == X && sd[1] == Y && sd[2] == Z && sd[3] == t && sd[4] == ext, "assembly and panels files disagree");
function len1(p) = p[1] - p[0];
tun_w = tn[1]; tun_l = tn[2];
for (c = [
    ["1010", "shell frame, horizontal", 2, sd[5]],
    ["1010", "shell frame, vertical", 2, sd[6]],
    ["1010", "door frame, top and bottom", 2, X],
    ["1010", "door frame, sides", 2, Z - 2 * ext],
    ["8 mm rod", "door bar", 1, bar_len()],
    ["8 mm rod", "holder rods", 4, holder_rod_len()],
]) echo(str("CUT | ", c[0], " | ", c[1], " | ", c[2], " x ", c[3]));
for (c = [
    ["tunnel floor", 1, tun_w, tun_l],
    ["tunnel walls", 2, deck_z - 2 * t, tun_l],
    ["tunnel deck", 1, tun_w, tn[3]],
    ["tray bottom", 1, dr[0], dr[1]],
    ["tray sides", 2, dr[1], dr[2] - t],
    ["tray ends", 2, dr[0] - 2 * t, dr[2] - t],
]) echo(str("CUT | acrylic | ", c[0], " | ", c[1], " x ", c[2], " x ", c[3]));
echo(str("TOTAL | 1010 ", 2 * sd[5] + 2 * sd[6] + 2 * X + 2 * (Z - 2 * ext) , " mm"));
