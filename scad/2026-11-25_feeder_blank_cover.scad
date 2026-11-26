// 2026-11-25: hollow cover for the U1's side panels where the two feeders were, with the WyoLum butterfly on the face.
// Credit: derived from "feeder_blank_plate.stl" in "Snapmaker U1 wire shelf filament feeder relocation" by kilozebra,
// https://www.printables.com/model/1618102-snapmaker-u1-wire-shelf-filament-feeder-relocation, licensed CC BY 4.0
// (https://creativecommons.org/licenses/by/4.0/). Changes are listed below.
// Attaches with four hooks like kilozebra's plate (a solid 58 x 61 x 12.5 block), redrawn from its measured
// dimensions: the hooks go into the panel's windows about 3.8 forward of the final spot, then the cover slides toward the
// printer's rear. To remove, slide toward the front and pull off.
// Changed from the plate: hollow, 31 clear between the hook pillars (the plate's channel was 28 x 5.5, the adapter board is
// 30 x 28 x 6); hooks 7.4 wide instead of 7.75 (the plate's reach 23.5 off centre, our windows end at 23.25) and thick all the
// way; lips wedge on the panel over the last of the slide instead of the plate's springy latch tab (the snap legs of the
// 2026-11-24 fit test broke, and a tab would too; the ribbon pulls toward the rear, which only tightens the wedge);
// angular sides like the 2026-11-25 mock-up; rear end at the panel's seam.
// The body is the same for both sides (turned 180); only the butterfly's direction differs.
// Print: face down, PETG. body + butterfly STL of a side loaded together as one object, two colours (or the body alone, engraved).
// Supports only under the four hook lips.
// Axes: x along the panel toward the printer's rear, y up (right side), z = 0 the panel's face, +z out. Units mm.
// part = "body" | "butterfly" (as printed) | "view" (gap, cut, show_cover as in the mock-up); side = "right" | "left"
use <2026-11-24_feeder_cover.scad>
use <2026-11-25_wyolum_butterfly.scad>
part = "view"; side = "right";
slide = 0; lift = 0; gap = 0; cut = false; show_cover = true;

base_x = [-22.5, 38.3]; base_y = 29;     // footprint on the panel: past the notch in front, to the seam behind
h      = 12.5;  flare = 3.5;             // off the panel; the flat face is this much smaller all around
wall   = 2;     face = 2;  inlay = 0.6;
// hooks: [window centre y, stem x front, stem x rear, lip reach, gap under the lip at the stem, at the lip's end, depth]
// panel thickness at the hooks: the feeder's own hooks had gaps of 5.0 and 6.7, the plate's 5.0 and 7.0
HOOKS  = [ [38.5 / 2,  -0.9,  5.1, 3.6, 6.4, 7.4, 10.5],
           [38.35 / 2, 27.2, 31.4, 3.6, 4.7, 5.6,  8.0] ];
hook_w = 7.4;
ribbon = [28, 5.5];                      // opening at the rear, like the plate's channel

e = 0.01;
module slab(d, z) translate([base_x[0] + d, -base_y + d, z]) cube([base_x[1] - base_x[0] - 2 * d, 2 * (base_y - d), 0.001]);
module shell(d, z0, z1) hull() { slab(d + flare * z0 / h, z0); slab(d + flare * z1 / h, z1 - 0.001); }
module xz(y0, y1) translate([0, y1, 0]) rotate([90, 0, 0]) linear_extrude(height = y1 - y0) children();

module hook(k) xz(k[0] - hook_w / 2, k[0] + hook_w / 2)
    polygon([[k[1] - 0.8, e], [k[2], e], [k[2], -k[4]], [k[2] + k[3], -k[5]], [k[2] + k[3], -k[6]], [k[1] + 0.8, -k[6]], [k[1], -k[6] + 0.8], [k[1], -0.8]]);
module pillars() intersection() {
    for (k = HOOKS, s = [0, 1]) mirror([0, s, 0])
        translate([k[1] - 1.5, k[0] - hook_w / 2, 0]) cube([(k[1] > 20 ? base_x[1] : k[2] + k[3] + 1) - (k[1] - 1.5), base_y, h - 1]);   // out to the side wall, under the whole lip
    shell(0.5, 0, h);
}
module body() {
    difference() {
        shell(0, 0, h);
        shell(wall, -1, h - face);
        translate([base_x[1] - 8, -ribbon[0] / 2, -1]) cube([20, ribbon[0], 1 + ribbon[1]]);
        face_art(h - inlay, inlay + 1);
    }
    pillars();
    for (k = HOOKS, s = [0, 1]) mirror([0, s, 0]) hook(k);
}
module face_art(z, t) translate([(base_x[0] + base_x[1]) / 2, 0, z]) rotate(side == "left" ? 180 : 0) linear_extrude(height = t) butterfly();
module as_printed() rotate([180, 0, 0]) translate([0, 0, -h]) children();

if (part == "body")      as_printed() body();
if (part == "butterfly") as_printed() face_art(h - inlay, inlay);
if (part == "check_board") intersection() { body(); union() { adapter(); cable(); } }                     // clashes, want empty
if (part == "check_panel") intersection() { translate([-slide, 0, lift]) body(); panel(); }            // slide 0: latched, 3.8: as pushed in
if (part == "view") rotate(side == "left" ? 180 : 0) {
    panel(); adapter(); cable();
    if (show_cover) translate([0, 0, gap]) { 
        color([0.16, 0.16, 0.18]) difference() { body(); if (cut) translate([-100, -100, 4]) cube([200, 200, 30]); }
        if (!cut) color([1, 0.55, 0.05]) face_art(h - inlay, inlay + 0.02);
    }
}
