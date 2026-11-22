// 2026-11-21: MOCK-UP of a smaller, 4-spool dry box on its own 2020 cart with casters.
// Same box system as DryBoxU1: 5.8 acrylic shell, 1010 front frame, door on 1010 with uprights,
// the same 2-spool roller holders, side by side on a perforated acrylic shelf, the SS6152
// desiccant pan on the floor UNDER the shelf (2026-11-21, Justin: shelf under the spools, so the
// box is only 2 holders wide). The shelf rests on 2 tunnel walls either side of the pan, as in the
// current box, and on ledges on the side walls. The pan slides out the front, lifting 10 over the
// front frame member. The 2 U1 feeders in the back wall, one behind each holder.
// Cart: 2020 base frame on 4 casters, open storage bay, box bay, plate for the U1 right on the box
// bay's upper rails (no drawer, 2026-11-21). Overall height matches the current cart, so the drawer's
// height goes to the storage bay. Heights measured on the current cart (Justin, 2026-11-21): top
// 880 from the floor, 750 from the top of the casters.
// Not a build file: no panel outlines, simplified door hardware. Units mm; x = width,
// y = depth (y = 0 is the shell's front edge), z = up (z = 0 is the box's bottom face).

use <2026-11-04_spool_holder.scad>

show_cart   = true;
show_top    = true;     // false: lift the box lid off
show_spools = true;
show_door   = true;
acrylic_alpha = 0.30;

// ---- heights from the floor (measured on the current cart, 2026-11-21) ----
cart_top     = 880;     // floor to the top of the top plate, where the U1 stands
caster_h     = 130;     // floor to the caster's mounting plate (880 - 750)
plate_t      = 3;       // top plate and storage floor (aluminium or acrylic)
// floor_to_box: in the cart section, once Z is known

// ---- box ----
t = 5.8; ext = 10; foam = 2.1;
hW       = 3 * 5.8 + 2 * 82;               // holder width, 181.4
w_off    = holder_wall_off();              // outer plate to the wall (cap clearance), 5.8
pan      = [153, 384, 51]; pan_so = 9;     // SS6152 body, handle stand-off
side     = 2 * w_off + hW;                 // one holder with cap room both sides
X = 2 * t + 2 * side;
Y = 430;                                   // the pan (402 with handles) sets the depth, as now
sh_clear = 66;                             // floor to the shelf's underside: pan 51 + 10 lift + 5
tun_in   = 157;                            // between the tunnel walls, as now
deck_top = t + sh_clear + t;               // spools' holders stand here
Z = 258 + deck_top - t;                    // the current box, raised by the shelf
top_in = Z - t; back_in = Y - t;

spool_y = 115; spool_d = 210; spool_w = 65;
roll_off = 65; roll_z = 20; roll_od = 28;
function axis_z(d) = roll_z + sqrt(pow(d / 2 + roll_od / 2, 2) - pow(roll_off, 2));
function sl_x(k) = 5.8 + 82 / 2 + k * (5.8 + 82);
hold_x = [t + w_off, X - t - w_off];       // left holder origin; right one turned 180
fed_x  = [hold_x[0] + sl_x(0), hold_x[0] + sl_x(1), hold_x[1] - sl_x(1), hold_x[1] - sl_x(0)];

// feeders: one per holder, centred behind it (the current box has them at 1/7 of the width)
hang_x = [hold_x[0] + hW / 2, hold_x[1] - hW / 2];
hang_y = back_in - foam + 0.2 - 33;
fd     = [58.4, 61.8, 55]; black_l = 26;
face_y = back_in - foam;
port_z = top_in - 40;

// ---- cart (2020) ----
z_upper  = Z + 12;                          // box bay upper rails' bottom, 12 over the box as now
floor_to_box = cart_top - plate_t - 20 - z_upper;   // floor to the box's bottom face
bx    = 20;
cl    = 4;                                  // box to post, each side
cart_x = [-cl - bx, X + cl];                // left posts' x; right posts' x
cart_w = X + 2 * cl + 2 * bx;               // outside width
rail_y = [41, 411];                         // front and back rails, as the current bay: box front 41 proud
cart_d = rail_y[1] + bx - rail_y[0];
z_floor  = -floor_to_box;
z_base   = z_floor + caster_h;              // bottom of the base frame
z_shelf  = -bx;                             // box bay lower rails, top at z 0
store_h  = z_shelf - (z_base + bx + plate_t);        // storage clear height
post_l   = z_upper + bx - z_base;

module acrylic(c = [0.80, 0.88, 1.0]) color([c[0], c[1], c[2], acrylic_alpha]) children();
module tube(d, h) difference() { cylinder(d = d, h = h, center = true, $fn = 96); cylinder(d = 55, h = h + 2, center = true, $fn = 32); }

// ================= opaque parts =================

// 1010 front frame inside the shell's front edge
color([0.75, 0.76, 0.78]) translate([t, 0.5, t]) difference() {
    cube([X - 2 * t, ext, Z - 2 * t]);
    translate([ext, -1, ext]) cube([X - 2 * t - 2 * ext, ext + 2, Z - 2 * t - 2 * ext]);
}

// holders and spools
for (k = [0 : 1]) translate([hold_x[k], spool_y, deck_top]) rotate([0, 0, k * 180]) {
    holder();
    if (show_spools) for (j = [0 : 1]) color("tomato") translate([sl_x(j), 0, axis_z(spool_d)]) rotate([0, 90, 0]) tube(spool_d, spool_w);
}

// desiccant pan on the floor, against the back wall, handles both ends
pan_y0 = back_in - 4 - pan_so - pan[1];
color([0.78, 0.79, 0.81]) translate([X / 2 - pan[0] / 2, pan_y0, t]) {
    difference() { cube(pan); translate([1, 1, 1]) cube(pan - [2, 2, 0]); }
    for (yy = [-pan_so, pan[1]]) translate([pan[0] / 2 - 57, yy, 6.5]) cube([114, pan_so, 5]);
}

// feeders, outlet seals, filament paths, tubes up to the printer
for (k = [0 : 1]) {
    fx = hang_x[k];
    color([0.95, 0.55, 0.1]) translate([fx, hang_y, top_in]) rotate([0, 0, 180]) import("../stl/feeder_insert_qty=2.stl");
    translate([fx, face_y, top_in]) {
        color([0.15, 0.15, 0.17]) translate([-fd[0] / 2, -black_l, -fd[2]]) cube([fd[0], black_l, fd[2]]);
        color("white") translate([-fd[0] / 2, -fd[1], -fd[2]]) cube([fd[0], fd[1] - black_l, fd[2]]);
    }
    for (j = [0 : 1]) {
        s = 2 * j - 1;
        color("red") hull() {
            translate([fed_x[2 * k + j], spool_y + 20, deck_top + axis_z(spool_d) + spool_d / 2 - 2]) sphere(d = 1.75, $fn = 8);
            translate([fx + s * 13, face_y - fd[1], port_z]) sphere(d = 1.75, $fn = 8);
        }
        color([0.92, 0.96, 1.0]) {
            translate([fx + s * 13, face_y, port_z]) rotate([-90, 0, 0]) cylinder(d = 4.1, h = 30, $fn = 16);
            translate([fx + s * 13, face_y + 30, port_z]) cylinder(d = 4.1, h = cart_top - floor_to_box - port_z + 60, $fn = 16);
        }
    }
}

// door, closed: 1010 outside frame, uprights at 1/4 and 3/4, knobs on top (hardware simplified)
door_y = -foam - t - 1 - ext;
if (show_door) {
    color([0.70, 0.71, 0.73]) translate([0, door_y, 0]) difference() {
        cube([X, ext, Z]);
        translate([ext, -1, ext]) cube([X - 2 * ext, ext + 2, Z - 2 * ext]);
    }
    for (lx = [X / 4, 3 * X / 4]) {
        color([0.70, 0.71, 0.73]) translate([lx - ext / 2, door_y - ext, -5]) cube([ext, ext, Z + 19]);   // upright
        color([0.2, 0.2, 0.22]) translate([lx, door_y - ext, Z + 14]) rotate([90, 0, 0]) cylinder(d = 22, h = 14, $fn = 32);   // knob
        color([0.95, 0.55, 0.1]) translate([lx - 15, 1, Z]) cube([30, 22, 14]);   // saddle
    }
    color([0.25, 0.25, 0.25]) translate([0, -foam, 0]) cube([X, foam, 4]);         // hinge line marker (bar under the front edge)
    color([0.55, 0.55, 0.58]) translate([0, 14.5 - 4, -10 - 4]) rotate([0, 90, 0]) cylinder(d = 8, h = X, $fn = 24);   // hinge bar
}

// cart
if (show_cart) {
    color([0.35, 0.36, 0.40]) {
        for (x = cart_x, y = rail_y) translate([x, y, z_base]) cube([bx, bx, post_l]);   // posts
        for (z = [z_base, z_shelf, z_upper]) {
            for (y = rail_y) translate([cart_x[0] + bx, y, z]) cube([cart_w - 2 * bx, bx, bx]);        // across
            for (x = cart_x) translate([x, rail_y[0] + bx, z]) cube([bx, cart_d - 2 * bx, bx]);        // front to back
        }
    }
    // top plate, storage floor
    color([0.82, 0.83, 0.85]) translate([cart_x[0], rail_y[0], z_upper + bx]) cube([cart_w, cart_d, plate_t]);
    color([0.82, 0.83, 0.85]) translate([cart_x[0] + bx, rail_y[0] + bx, z_base + bx]) cube([cart_w - 2 * bx, cart_d - 2 * bx, plate_t]);
    // casters: plate, fork, red wheel
    for (x = cart_x, y = rail_y) translate([x + bx / 2, y + bx / 2, z_base]) {
        color([0.6, 0.6, 0.62]) translate([-30, -30, -4]) cube([60, 60, 4]);
        color([0.6, 0.6, 0.62]) translate([-22, -6, -caster_h + 37]) cube([44, 12, caster_h - 41]);
        color([0.8, 0.12, 0.12]) translate([-12, 0, -caster_h + 37]) rotate([0, 90, 0]) cylinder(d = 74, h = 24, $fn = 48);
    }
    // stored spools in the bay: 1 stack of 4, flat (2 side by side no longer fit the 406 width)
    if (show_spools) for (j = [0 : 3]) color("burlywood")
        translate([X / 2, (rail_y[0] + rail_y[1] + bx) / 2, z_base + bx + plate_t + spool_w / 2 + j * (spool_w + 0.5)])
            tube(spool_d, spool_w);
}

// ================= acrylic last =================
// shelf: tunnel walls either side of the pan, ledges on the side walls, perforated deck
acrylic() {
    for (x = [X / 2 - tun_in / 2 - t, X / 2 + tun_in / 2]) translate([x, ext + 0.5, t]) cube([t, back_in - ext - 0.5, sh_clear]);
    for (x = [t, X - t - 12]) translate([x, ext + 0.5, t + sh_clear - 12]) cube([12, back_in - ext - 0.5, 12]);
}
acrylic([0.85, 0.92, 1.0]) translate([t, ext + 0.5, t + sh_clear]) difference() {
    cube([X - 2 * t, back_in - ext - 0.5, t]);
    for (i = [0 : 4], j = [0 : 9]) translate([X / 2 - t + (i - 2) * 28, 30 + j * 38, -1]) cylinder(d = 12, h = t + 2, $fn = 16);
}
acrylic() {
    cube([X, Y, t]);                                              // bottom
    translate([0, Y - t, t]) cube([X, t, Z - 2 * t]);             // back
    for (x = [0, X - t]) translate([x, 0, t]) cube([t, Y - t, Z - 2 * t]);   // sides
    if (show_top) translate([0, 0, Z - t]) cube([X, Y, t]);       // top
}
if (show_door) acrylic([0.85, 0.92, 1.0]) translate([ext / 2, door_y - t, ext / 2]) cube([X - ext, t, Z - ext]);   // door panel

echo(str("4-spool box ", X, " x ", Y, " x ", Z, " (now 640 x 430 x 258); shelf top ", deck_top, ", side bays under the shelf ", X / 2 - tun_in / 2 - 2 * t, " wide",
         "; cart ", cart_w, " wide x ", cart_d, " deep x ", cart_top, " tall (now 688 wide)",
         "; storage clear height ", store_h, ", clear width ", cart_w - 2 * bx,
         "; feeders at x ", hang_x[0], ", ", hang_x[1], " (", hang_x[1] - hang_x[0], " apart; now 448.8)",
         "; box bottom ", floor_to_box, " above the floor"));
