// 2026-11-14: collet release tool, laser cut from 1/4 in (6 mm) cast acrylic, one per feeder.
// It lives on the feeder's two PTFE tubes behind the box: thread the tubes through its two holes
// before pushing them into the collets (2026-11-14: closed holes, not open slots), and pushing it along the tubes into the back panel's obround port presses both collet
// rings at once, so the tubes pull out. Stack, solvent cemented with the slots aligned:
//   2 x pusher: obround that fits inside the port (16 x 42) and the gasket hole (16.4 x 42.4)
//   1 x handle: wider grip outside the port.
// Port depth is about 6 (acrylic) + 2 (compressed EVA), so the 2 pushers (about 12) reach the
// collets with the handle still clear of the wall. Sizes below are finished sizes; cut()
// adds the kerf. Collets 26 apart, ring 10, tube 4.1 (measured). Units mm.
// 2026-11-14: the cut file is now a single pusher (Justin: just the smallest piece); the stack
// and handle are kept below for reference.
// part = "sheet" (1 pusher) | "view" (3D stack).

part = "sheet";

pd     = 26;       // collet centers
tube   = 4.1;
slot   = 4.6;      // slides over the tube
push_w = 15;       // port 16: 0.5 clear per side
push_l = pd + push_w;
hdl    = [80, 30]; // grip, along x, along y
hdl_y0 = -10;      // its bottom edge, below the collet centers (y = 0)
t      = 6;
kerf   = 0.25;

module cut() offset(delta = kerf / 2) children();
module slots(y0) for (s = [-1, 1]) translate([s * pd / 2, 0]) circle(d = slot, $fn = 32);   // closed holes: thread onto the tubes (y0 unused)
module pusher2d() difference() {
    hull() for (s = [-1, 1]) translate([s * pd / 2, 0]) circle(d = push_w, $fn = 64);
    slots(-push_w / 2);
}
module handle2d() difference() {
    translate([-hdl[0] / 2, hdl_y0]) offset(r = 4, $fn = 32) offset(delta = -4) square(hdl);
    slots(hdl_y0);
}

if (part == "sheet") {
    translate([5 + push_l / 2, 5 + push_w / 2]) cut() pusher2d();   // 2026-11-14: one pusher only, no stack or handle
} else if (part == "view") {
    for (i = [0 : 1]) color([0.8, 0.9, 1, 0.8]) translate([0, 0, i * t]) linear_extrude(t) pusher2d();
    color([0.9, 0.95, 1, 0.8]) translate([0, 0, 2 * t]) linear_extrude(t) handle2d();
}
echo(str("pusher ", push_l, " x ", push_w, ", slots ", slot, " for tube ", tube, "; handle ", hdl));
