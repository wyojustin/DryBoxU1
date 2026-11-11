// 2026-10-30: dry box panels nested on strips ripped from 603 x 910 cast acrylic sheets (measured
// 2026-11-09). The xTool P3 takes stock up to 530 wide (work area 915 x 458), so the sheets are ripped
// by hand with a circular saw (rip plan render: commit 774f584, renders/2026-11-11_rip_plan.png): sheet A in the middle (two ~300.6
// strips: back, door), sheets B and C at 450 from a factory edge (one 450 x 910 strip each, for the
// 430-deep shell; 151 offcuts kept).
// strip = 1: top + left (450 strip), 2: bottom + right (450 strip),
//         3: back (300 strip), 4: door (300 strip).
// Parts are centered along the 910 length and sit margin from the factory edge (y = 0).
// Place the job at the strip corner, factory edge at y = 0.
// Units mm.

use <2026-10-30_dry_box_panels.scad>

strip  = 1;
L      = 910;     // strip length (stock)
margin = 5;       // from the factory edge
gap    = 3;       // 2026-11-11: 6 -> 3, so top/bottom + side fit the 910 strip with 4.25 each end

// outline extents, from the panels file (t = 5.8, kerf 0.25): top/bottom 640.25 x 430.25,
// sides 258.25 x 430.25 after rotation, back and door 640.25 x 258.25
w12 = 640.25 + gap + 258.25;              // strips 1, 2 along the length: 901.5
x12 = (L - w12) / 2;                      // 4.25 each end
x34 = margin;                             // back, door at one end: leaves one ~265 x 300 offcut
module place(x, y) { translate([x + 0.125, margin + 0.125 + y]) children(); }   // kerf/2 outside the outline

if (strip == 1) { place(x12, 0) panel2d("top");    place(x12 + 640.25 + gap, 0) panel2d("left"); }
if (strip == 2) { place(x12, 0) panel2d("bottom"); place(x12 + 640.25 + gap, 0) panel2d("right"); }
if (strip == 3)   place(x34, 258) panel2d("back");     // back's outline lies at negative y
if (strip == 4)   place(x34, 0) door_cut();

echo(str("strip ", strip, ": strips 1, 2 use ", w12, " of ", L, " (", x12, " each end); back/door at x ", x34));
