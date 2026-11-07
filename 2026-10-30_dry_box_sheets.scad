// 2026-10-30: dry box panels nested on strips ripped from 24" x 36" cast acrylic sheets.
// Rip sheet A at 268 and 536 mm (two 268 strips: back, door), sheets B and C at 442 mm
// (one 442 x 914.4 strip each, for the 430-deep shell); rip files are
// cut/2026-10-30_dry_box_rip_{A,BC}.svg.
// strip = 1: top + left (442 strip), 2: bottom + right (442 strip),
//         3: back (268 strip), 4: door (268 strip).
// Parts start at (margin, margin) from the strip corner; place the job at the strip corner.
// Units mm.

use <2026-10-30_dry_box_panels.scad>

strip  = 1;
margin = 5;
gap    = 6;

// outline extents, from the panels file (t = 5.8): top/bottom 640 x 430,
// sides 258 x 430 after rotation, back and door 640 x 258 (strips 1, 2 use 435.1 of 442)
module place(x, y) { translate([margin + x, margin + y]) children(); }

if (strip == 1) { place(0, 0) panel2d("top");    place(640 + gap, 0) panel2d("left"); }
if (strip == 2) { place(0, 0) panel2d("bottom"); place(640 + gap, 0) panel2d("right"); }
if (strip == 3)   place(0, 258) panel2d("back");     // back's outline lies at negative y
if (strip == 4)   place(0, 0) door_cut();
