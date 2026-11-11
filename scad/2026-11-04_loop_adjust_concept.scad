// 2026-11-04: CONCEPT, adjustable top seal, SUPERSEDED 2026-11-05: now built into 2026-11-04_door_mounts.scad. The bar sits in a short
// y-slot in the loop; per cheek, an M3 x 10 grub screw from the loop's front face (1.5 mm hex
// key) runs through a captured nut (dropped in from the top) and bears on the bar's front.
// Turning in pushes the bar back, which pulls the hook and door top into the foam (0.5 mm per
// turn, 3 mm travel). Flush grub screws, not knobs: a knob in front of the loop blocks the door
// frame when the door swings open. The nut reacts forward against a 4 mm front wall, a plate held
// on its bottom and both sides (Justin: 1.5 was too thin). That pushes the bar back to y 14.5 and
// the loop to 38 deep; its 2 panel screws move to y 32 (top-panel holes would change again).
// view = "3d" | "section" (2D cut through one adjuster, front at left).
use <2026-11-04_door_mounts.scad>

view = "3d";

X = 640; Z = 258; t = 5.8; ext = 10; foam = 2.1;
door_y0 = -foam - t; df_y = [door_y0 - ext, door_y0]; df_mid = (df_y[0] + df_y[1]) / 2;
lp = [47, 38, 20]; ch_w = 21; slot_l = 26;     // back wall 26 .. 38
bar_d = 8; bar_bore = 8.25; bar_y = 14.5; bar_z = Z + 10; travel = 3;
hk_w = 20; hk_t = 4; ri = 6; sweep = 120;
cc = [bar_y + bar_d / 2 - ri, Z + hk_t + ri];
adj_x = (ch_w / 2 + lp[0] / 2) / 2;          // adjuster on each cheek's centre line (17)
nut = [5.7, 2.7];                             // M3 nut pocket: flats + clearance, thickness
nut_y = 4;                                    // front wall in front of the nut
grub_l = 10;
screw_xy = [[-15, 32], [15, 32]];

module bar_slot2d() hull() for (dy = [-travel / 2, travel / 2]) translate([bar_y + dy, bar_z]) circle(d = bar_bore, $fn = 32);

module loop() {
    difference() {
        translate([-lp[0] / 2, 0, Z]) cube(lp);
        translate([-ch_w / 2, -1, Z - 1]) cube([ch_w, slot_l + 1, lp[2] + 2]);
        translate([-lp[0] / 2 - 1, 0, 0]) rotate([90, 0, 90]) linear_extrude(lp[0] + 2) bar_slot2d();
        for (m = [-1, 1]) translate([m * adj_x, 0, bar_z]) {
            translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = bar_y, $fn = 24);   // screw
            translate([-nut[0] / 2, nut_y, -nut[0] / 2 / cos(30)]) cube([nut[0], nut[1], lp[2]]);   // nut drop-in
        }
        for (s = screw_xy) translate([s[0], s[1], Z - 1]) {
            cylinder(d = 3.4, h = lp[2] + 2, $fn = 24);
            translate([0, 0, 1 + 4]) cylinder(d = 6.2, h = lp[2], $fn = 32);
        }
    }
}
module hook_profile() {
    ro = ri + hk_t;
    a = [for (i = [0 : 48]) -90 + i * sweep / 48];
    translate([df_y[0], Z]) square([cc[0] - df_y[0], hk_t]);
    translate(cc) polygon(concat([for (b = a) ro * [cos(b), sin(b)]],
                                 [for (i = [len(a) - 1 : -1 : 0]) ri * [cos(a[i]), sin(a[i])]]));
}
module hook() translate([-hk_w / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(hk_w) hook_profile();
module grub() color([0.15, 0.15, 0.17]) rotate([-90, 0, 0]) difference() {   // M3 x grub_l, hex socket at the front
    cylinder(d = 3, h = grub_l, $fn = 16);
    translate([0, 0, -1]) cylinder(d = 1.6, h = 3, $fn = 6);
}
module adjusters() for (m = [-1, 1]) translate([m * adj_x, bar_y - bar_d / 2 - grub_l, bar_z]) grub();

module slab(y0, y1, z0, z1) translate([y0, z0]) square([y1 - y0, z1 - z0]);

if (view == "3d") {
    context();
    color([0.95, 0.55, 0.1]) loop();
    color([0.55, 0.55, 0.58]) translate([-lp[0] / 2, bar_y, bar_z]) rotate([0, 90, 0]) cylinder(d = bar_d, h = lp[0], $fn = 32);
    color([0.2, 0.2, 0.22]) hook();
    adjusters();
    color("silver") for (m = [-1, 1]) translate([m * adj_x, nut_y + 0.1, bar_z]) rotate([-90, 0, 0]) rotate(30) cylinder(d = 5.5 / cos(30), h = 2.4, $fn = 6);
} else {
    // section on one adjuster's axis (x = adj_x): loop cheek, slot, nut, screw, bar; hook drawn behind
    color([0.80, 0.88, 1.0]) slab(0, 45, Z - t, Z);
    color([0.75, 0.76, 0.78]) slab(0, ext, Z - t - ext, Z - t);
    color([0.25, 0.25, 0.25]) slab(-foam, 0, Z - 18, Z);
    color([0.85, 0.92, 1.0]) slab(door_y0, -foam, Z - 30, Z);
    color([0.70, 0.71, 0.73]) slab(df_y[0], door_y0, Z - ext, Z);
    color([0.2, 0.2, 0.22]) translate([0, 0, -2]) render() hook_profile();
    color([0.95, 0.55, 0.1]) render() difference() {
        slab(0, lp[1], Z, Z + lp[2]);
        bar_slot2d();
        translate([-1, bar_z - 1.7]) square([bar_y, 3.4]);
        translate([nut_y, bar_z - nut[0] / 2 / cos(30)]) square([nut[1], lp[2]]);
        for (s = [32]) translate([s - 1.7, Z - 1]) square([3.4, lp[2] + 2]);
    }
    color([0.55, 0.55, 0.58]) translate([bar_y, bar_z, 1]) circle(d = bar_d, $fn = 48);
    color("silver") translate([nut_y + 0.1, bar_z - 2.75, 1]) square([2.4, 5.5]);
    color([0.15, 0.15, 0.17]) translate([bar_y - bar_d / 2 - grub_l, bar_z - 1.5, 1]) square([grub_l, 3]);
}
