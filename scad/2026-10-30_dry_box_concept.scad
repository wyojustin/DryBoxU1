// 2026-10-30: concept layout for a sealed spool box in the cart's middle bay.
// Bay 647 W x 265 H x 390 D. Fixed box (polycarbonate panels, butt joints sealed with
// silicone), printed front frame carrying a foam gasket, drop-down front door,
// spools on 608-bearing roller cradles, PTFE feed tubes out through the back panel.
// Units mm. Axes: x = width, y = depth (y = 0 is the front), z = up.

bay = [647, 390, 265];
gap = [7, 5, 7];             // total clearance to the bay on each axis
box = bay - gap;             // outer envelope 640 x 385 x 258

t       = 3.175;             // 1/8" polycarbonate panels
door_t  = t;
gasket  = 3;                 // compressed foam gasket between frame and door
frame_w = 15;                // printed front frame: face width (gasket seat)
frame_d = 12;                // printed front frame: depth into the box
D_body  = box[1] - door_t - gasket;   // panel box depth behind the door

spool_d    = 210;            // largest 1 kg spool expected
spool_w    = 75;
hub_d      = 55;
n_slots    = 7;
n_feed     = 4;              // slots with a PTFE feed fitting in the back panel
lift       = 12;             // spool rim clearance above the floor
roller_d   = 22;             // 608 bearing OD
roller_off = 65;             // rollers at +-roller_off from the spool axis, along y
tray_d     = 70;             // desiccant tray depth along y, in front of the spools
tray_h     = 30;
show_top   = true;        // false for a cutaway render
show_door  = true;

y0      = door_t + gasket;                       // front face of the panel box
pitch   = (box[0] - 2 * t) / n_slots;
spool_z = t + lift + spool_d / 2;
spool_y = y0 + frame_d + tray_d + 10 + spool_d / 2;
roller_z = spool_z - sqrt(pow(spool_d / 2 + roller_d / 2, 2) - pow(roller_off, 2));
feed_z  = spool_z + 60;

echo(str("box ", box[0], " x ", box[1], " x ", box[2], " mm; slot pitch ", pitch,
         " mm; spool top ", spool_z + spool_d / 2, " of inner ", box[2] - t,
         "; spool back ", spool_y + spool_d / 2, " of inner ", y0 + D_body - t));
echo("cut list (polycarbonate, 3.175 mm):");
echo(str("  top, bottom (2): ", box[0], " x ", D_body));
echo(str("  sides (2):       ", box[2] - 2 * t, " x ", D_body));
echo(str("  back (1):        ", box[0] - 2 * t, " x ", box[2] - 2 * t));
echo(str("  door (1):        ", box[0], " x ", box[2]));

module panels() {
    color([0.85, 0.9, 1.0, 0.25]) {
        translate([0, y0, 0])                cube([box[0], D_body, t]);          // bottom
        if (show_top) translate([0, y0, box[2] - t]) cube([box[0], D_body, t]);  // top
        translate([0, y0, t])                cube([t, D_body, box[2] - 2 * t]);  // left
        translate([box[0] - t, y0, t])       cube([t, D_body, box[2] - 2 * t]);  // right
        translate([t, y0 + D_body - t, t])   cube([box[0] - 2 * t, t, box[2] - 2 * t]); // back
    }
}

module front_frame() {
    color("dimgray") translate([t, y0, t]) difference() {
        cube([box[0] - 2 * t, frame_d, box[2] - 2 * t]);
        translate([frame_w, -1, frame_w])
            cube([box[0] - 2 * t - 2 * frame_w, frame_d + 2, box[2] - 2 * t - 2 * frame_w]);
    }
}

module door() {
    color([0.85, 0.9, 1.0, 0.35]) cube([box[0], door_t, box[2]]);
    color("black") translate([0, door_t, 0]) difference() {   // gasket ring
        translate([t, 0, t]) cube([box[0] - 2 * t, gasket, box[2] - 2 * t]);
        translate([t + frame_w, -1, t + frame_w])
            cube([box[0] - 2 * t - 2 * frame_w, gasket + 2, box[2] - 2 * t - 2 * frame_w]);
    }
}

module spool(x) {
    color("orange") translate([x, spool_y, spool_z]) rotate([0, 90, 0]) difference() {
        cylinder(d = spool_d, h = spool_w, center = true, $fn = 72);
        cylinder(d = hub_d, h = spool_w + 2, center = true, $fn = 36);
    }
}

module cradle(x) {
    color("silver") for (s = [-1, 1])
        translate([x, spool_y + s * roller_off, roller_z]) rotate([0, 90, 0])
            cylinder(d = roller_d, h = spool_w + 10, center = true, $fn = 24);
    color("dimgray") translate([x - (spool_w + 16) / 2, spool_y - roller_off - 15, t])
        cube([spool_w + 16, 2 * roller_off + 30, roller_z - t - roller_d / 2 + 2]);
}

module feed_fitting(x) {
    color("royalblue") translate([x, y0 + D_body - t / 2, feed_z]) rotate([-90, 0, 0])
        cylinder(d = 16, h = 25, center = true, $fn = 24);
}

module tray() {
    color("khaki") translate([t + 20, y0 + frame_d + 5, t])
        cube([box[0] - 2 * t - 40, tray_d - 5, tray_h]);
}

module bay_outline() {
    %translate([-gap[0] / 2, 0, 0]) cube(bay);
}

panels();
front_frame();
if (show_door) door();
tray();
for (i = [0 : n_slots - 1]) {
    x = t + pitch * (i + 0.5);
    spool(x);
    cradle(x);
    if (i < n_feed) feed_fitting(x);
}
