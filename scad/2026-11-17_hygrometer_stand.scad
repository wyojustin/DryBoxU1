// 2026-11-17: stand for the reference hygrometer (face 64 wide x 80 tall, portrait, 21 deep,
// Justin), laser cut from 1/4 in acrylic scrap. Three pieces, egg-crate half-laps, no glue
// (rethought per Justin: the sides run all the way up the back, a brace behind locks them):
//   sides (2, same part): solid, standing on edge front to back, 1/3 and 2/3 across.
//          The meter's bottom sits on a ledge with a hook at its front edge, and its back leans on
//          the sides' front edges, 25 degrees back from vertical (Justin). The ledge is square to
//          that edge, so the meter slides back against it by itself (its own 5 to 10 degree bottom
//          bevel leans it a little further). Each has a slot up from its bottom edge, at the back.
//   brace: upright, across the back between the sides, slots down from its top edge. It locks
//          the sides together and never touches the meter.
// Sizes are finished; cut() adds kerf.
// part = "side" (cut 2) | "brace" (cut 1), one piece per file to place on scraps (Justin)
//      | "sheet" (all 3) | "view" (3D, assembled, with the meter). Units mm.
// Side profile: y forward (toward the reader), z up; lean coords: u up the lean, v out of it.

part = "sheet";

face  = [64, 80];         // hygrometer face, width x height: portrait (Justin)
dev_d = 21;               // hygrometer depth (Justin)
a     = 25;               // lean back from vertical (Justin)
t     = 5.8;              // acrylic: caliper the scrap
slot  = t + 0.2;          // finished slot width
kerf  = 0.20;

fx    = face[0] / 6;      // sides at +-fx: 1/3 and 2/3 across the meter (Justin, 2026-11-17)
hl    = 3;                // ledge top, up the lean from the table line: the meter sits about 3 off the table
ll    = dev_d + 0.5;      // ledge depth: the meter plus a little play
lip   = [4, 6];           // hook at the ledge's front edge, thick x tall
top   = 60;               // sides' top, up the lean (the meter is 80 tall)
sb    = 6;                // side thickness behind the lean edge, at the top
tail  = -sin(a) * top - cos(a) * sb;   // the sides' back edge, straight down from their top back corner

bh    = 30;               // brace height
bw    = 2 * fx + t + 8;   // brace width: 4 past each side's outer face (Justin: shortened to suit)
by    = -20;              // brace center, y (its front face at by + t / 2, behind the meter)

module cut() offset(delta = kerf / 2) children();
module ln(pts) multmatrix([[-sin(a), cos(a), 0, 0], [cos(a), sin(a), 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]) polygon(pts);   // (u, v) -> (y, z)

module side2d() difference() {
    intersection() {
        hull() {
            ln([[-30, -sb], [top, -sb], [top, 0], [-30, 0]]);                                  // up the lean
            ln([[-30, 0], [hl, 0], [hl, ll + lip[0]], [-30, ll + lip[0]]]);                    // ledge
            ln([[-30, ll], [hl + lip[1], ll], [hl + lip[1], ll + lip[0]], [-30, ll + lip[0]]]); // hook
            translate([tail, 0]) square([1, 1]);                                               // back of the base
        }
        translate([tail, 0]) square([400, 200]);                                               // on the table, nothing behind the tail
    }
    ln([[hl, 0], [200, 0], [200, ll], [hl, ll]]);                                              // the meter
    ln([[hl + lip[1], ll], [200, ll], [200, 200], [hl + lip[1], 200]]);                        // above the hook
    translate([by - slot / 2, -1]) square([slot, bh / 2 + 1]);                                 // brace slot, up from the bottom
}
module brace2d() difference() {                                                                 // x across, y up
    translate([-bw / 2, 0]) offset(r = 3, $fn = 24) offset(delta = -3) square([bw, bh]);
    for (s = [-1, 1]) translate([s * fx - slot / 2, bh / 2]) square([slot, bh / 2 + 1]);       // slots down from the top
}

if (part == "side") translate([5 - tail, 5]) cut() side2d();
else if (part == "brace") translate([5 + bw / 2, 5]) cut() brace2d();
else if (part == "sheet") {
    translate([5 + bw / 2, 5]) cut() brace2d();
    for (i = [0 : 1]) translate([5 + bw + 5 - tail + i * (-tail + 32 + 3), 5]) cut() side2d();
} else if (part == "view") {
    for (s = [-1, 1]) color([0.85, 0.92, 1, 0.8]) translate([s * fx, 0, 0]) rotate([90, 0, 90]) translate([0, 0, -t / 2]) linear_extrude(t) side2d();
    color([0.85, 0.92, 1, 0.8]) translate([0, by + t / 2, 0]) rotate([90, 0, 0]) linear_extrude(t) brace2d();
    M = [[1, 0, 0, 0], [0, -sin(a), cos(a), 0], [0, cos(a), sin(a), 0], [0, 0, 0, 1]];         // lean coords (x, u, v) -> world
    color("dimgray") multmatrix(M) translate([-face[0] / 2, hl, 0]) cube([face[0], face[1], dev_d]);
}
// the meter's back plane at the brace's top: y = -(bh) tan(a); the brace's front face must be behind it
echo(str("stand: sides at +-", fx, ", lean ", a, ", ledge ", ll, " + hook ", lip, ", top ", top, ", tail ", tail,
         "; brace ", bw, " x ", bh, ", front face y ", by + t / 2, " vs meter back at its top y ", -bh * tan(a),
         (by + t / 2 < -bh * tan(a) ? " (clear)" : " (HITS THE METER)"), "; slot ", slot, " for t ", t));
