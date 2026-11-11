// 2026-10-30: laser-cut 6 mm cast acrylic dry box for the cart's middle bay (647 x 390 x 265).
// Finger-jointed shell (bottom, top, left, right, back), a 10 x 10 aluminum extrusion
// frame inside the front opening (rubber cord pressed into its front slot is the door
// seal; hinges and latches bolt to it), and a plain door (hinge and latch holes later).
// part = "assembly" for a 3D view; a panel name gives its 2D cut outline (export SVG);
// solid = "<panel>" gives that panel as a 3D solid instead (used for checks).
// Axes: x = width, y = depth (y = 0 is the shell's front edge), z = up. Units mm.

part   = "assembly";
solid  = "";
t      = 5.8;      // sheet thickness: "6 mm" cast acrylic, 2026-11-02 caliper maps of the 4 sheets:
                   // bare about 5.4 to 6.0, typical 5.6 to 5.7 (film 0.1 to 0.3). Set near the thick
                   // end so fingers are never recessed; thin spots stand <= 0.4 proud, sand flush.
kerf   = 0.25;     // laser kerf (xTool P3, 6 mm cast acrylic: 0.25 snug in the 2026-10-30 coupon)
finger = 30;       // target finger width
// holes cut smaller than the joints predict: the 0.20-kerf coupon's 10.5 hole measured
// 10.4, i.e. the laser widens small holes by only ~0.10. Holes are drawn so they come
// out at their nominal size after the kerf offset.
hole_kerf = 0.10;
function hole(d) = d + kerf - hole_kerf;

// 2026-11-03: the box rides on the bay's front and back 2020 rails (645 W x 270 H clear,
// shelf lowered; back of the bay open); the door (with its outside 1010 frame and the
// 2.1 mm foam) stands in front of the bay.
// 2026-11-04: shell 430 deep: its front stands 41 mm proud of the bay (20 mm to clear the
// door latches' saddles from the shelf rail, +20 for the 2020 drawer face above) and its back
// still sits 19 mm onto the bay's back rail (back edge at 389 of the 390 bay).
outer  = [640, 430, 258];        // shell width, depth, height
X = outer[0];
Y = outer[1];                    // shell depth; the door sits in front of it
Z = outer[2];

// front frame: 10 x 10 extrusion, flush with the shell's front edge, slot facing forward.
// Top and bottom run the full inside width; the verticals fit between them.
ext      = 10;
ext_h    = X - 2 * t;            // horizontal members
ext_v    = Z - 2 * t - 2 * ext;  // vertical members
screw_d  = 3.4;                  // M3 clearance; screws go into the frame's outer slot (T-nuts)
// 1010 T-slot screws: the channel is 3.2 mm deep from the extrusion face, so the screw tip
// may reach at most tnut_tip past the face (0.2 mm margin). Frame screws: M3 x 8 through t
// reach 8 - t = 2.2 mm (tested 2026-10-30: fits without a washer, no cracking at 5 mm
// edge distance). Anything bolted to the frame (hinges, latches): screw length <=
// part thickness + tnut_tip. Screws that don't go into a T-nut can be longer.
channel  = 3.2;
tnut_tip = channel - 0.2;       // 3.0 mm
n_screw_h = 4;                   // per horizontal member, through the top and bottom panels
n_screw_v = 2;                   // per vertical member, through the side panels

// spool slots
n_slots = 7;
lift    = 12;
spool_d = 210;
spool_z = t + lift + spool_d / 2;
pitch   = (X - 2 * t) / n_slots;
// feeder openings in the top panel: the U1 feeders hang under the top on 3D printed inserts
// that drop into these openings (flange on the top face, sealed with RTV); the insert
// carries the hook windows and latch, and the feeder cable leaves up through it.
// Centered between the two spools each feeder serves (slots 0 | 1 and 5 | 6).
hang_x   = [t + pitch, X - t - pitch];
// 2026-11-03: the feeder's outlet face sits flush with the insert edge (insert v7), and seals
// on 2.1 mm compressed foam against the back wall's inner face, so the opening's back edge
// is the inner face - foam + the insert's 0.2 clearance. Leaves a 1.9 mm web before the joint.
foam     = 2.1;
hang_y   = (Y - t) - foam + 0.2 - 66 / 2;   // 338.5
hang_wh  = [72, 66];             // along x, along y: 61.4 feeder face + ~5 mm insert wall
hang_r   = 3;
// outlet ports in the back panel: the feeders' outlet faces seal against the back wall's
// inner face (square foam ring), so their push-fit collets sit in these obround ports and the
// tubes can be released from outside. One port per feeder spanning both collets. The feeder's
// two case screws are replaced by 2.8 x 35-40 self-tappers driven from behind through
// screw_d2 holes, clamping feeder and seal to the wall.
cord_d   = 19.8;                 // heater cord hole, back panel: PG13.5 gland, thread 19.6 measured 2026-11-08
cord_xz  = [110, 130];
port_dx  = 26;                   // collet centers (measured)
port_d   = 16;                   // port width: collet ring 10 + 3 each side for fingers / a tool
port_z   = Z - t - 40;           // collet centers 40 below the box's inside top (measured)
case_dx  = (54.2 + 39.6) / 2;    // feeder case screws, 46.9 center to center (measured)
case_z   = Z - t - 30;           // 30 below the box's inside top (measured)
screw_d2 = 3.1;                  // clearance for the 2.8 self-tappers

// slabs as [[x0, x1], [y0, y1], [z0, z1]]
SLAB = [
    ["bottom", [[0, X],     [0, Y],     [0, t]]],
    ["top",    [[0, X],     [0, Y],     [Z - t, Z]]],
    ["left",   [[0, t],     [0, Y],     [0, Z]]],
    ["right",  [[X - t, X], [0, Y],     [0, Z]]],
    ["back",   [[0, X],     [Y - t, Y], [0, Z]]],
];
// joints: [owner of even segments, owner of odd segments, axis, a0, a1]
// the bar is the overlap of the two slabs, limited to [a0, a1) along the axis;
// the back corner cubes are excluded from the bars and belong to the back (CORNER)
JOINT = [
    ["left",  "bottom", 1, 0, Y - t],
    ["right", "bottom", 1, 0, Y - t],
    ["left",  "top",    1, 0, Y - t],
    ["right", "top",    1, 0, Y - t],
    ["back",  "bottom", 0, t, X - t],
    ["back",  "top",    0, t, X - t],
    ["back",  "left",   2, t, Z - t],
    ["back",  "right",  2, t, Z - t],
];
// 2026-11-11: the back owns all 4 back corner cubes. Owned by top/bottom, each cube hung on a 0.25
// diagonal pinch (both neighbouring finger segments belong to other panels) and would fall out.
// The back owns the end segment of both joints meeting each corner, so the cube joins it solidly.
CORNER = [  // [owner, cube]
    ["back", [[0, t],     [Y - t, Y], [0, t]]],
    ["back", [[X - t, X], [Y - t, Y], [0, t]]],
    ["back", [[0, t],     [Y - t, Y], [Z - t, Z]]],
    ["back", [[X - t, X], [Y - t, Y], [Z - t, Z]]],
];

function slab(name)  = SLAB[search([name], SLAB)[0]][1];
function isect(a, b) = [for (i = [0 : 2]) [max(a[i][0], b[i][0]), min(a[i][1], b[i][1])]];
function with_axis(b, ax, lo, hi) = [for (i = [0 : 2]) i == ax ? [lo, hi] : b[i]];
function nseg(L) = let(n = max(3, round(L / finger))) n % 2 == 1 ? n : n + 1;
function inside(b, c) = b[0][0] >= c[0][0] && b[0][1] <= c[0][1] && b[1][0] >= c[1][0]
                     && b[1][1] <= c[1][1] && b[2][0] >= c[2][0] && b[2][1] <= c[2][1];

module box(b) {
    translate([b[0][0], b[1][0], b[2][0]])
        cube([b[0][1] - b[0][0], b[1][1] - b[1][0], b[2][1] - b[2][0]]);
}

module panel3d(name) {
    // 2026-11-03: across each feeder opening the top/back joint is one solid back-panel tab
    // (no fingers), and the top panel's opening runs out through its back edge over it
    if (name == "back")
        for (x = hang_x)
            box([[x - hang_wh[0] / 2, x + hang_wh[0] / 2], [Y - t, Y], [Z - t, Z]]);
    difference() {
        box(slab(name));
        // finger segments owned by the other panel of each joint
        for (j = JOINT) if (j[0] == name || j[1] == name) {
            bar = isect(slab(j[0]), slab(j[1]));
            n = nseg(j[4] - j[3]);
            s = (j[4] - j[3]) / n;
            for (k = [0 : n - 1]) if (j[k % 2] != name)
                box(with_axis(bar, j[2], j[3] + k * s, j[3] + (k + 1) * s));
        }
        // corner cubes owned by another panel
        for (c = CORNER) if (c[0] != name && inside(c[1], slab(name))) box(c[1]);
        // frame screws, centered on the extrusion depth
        if (name == "bottom" || name == "top")
            for (i = [0 : n_screw_h - 1])
                translate([t + ext_h * (i + 0.5) / n_screw_h, ext / 2, (name == "bottom" ? 0 : Z - t) - 1])
                    cylinder(d = hole(screw_d), h = t + 2, $fn = 24);
        if (name == "left" || name == "right")
            for (i = [0 : n_screw_v - 1])
                translate([(name == "left" ? 0 : X - t) - 1, ext / 2, t + ext + ext_v * (i + 0.5) / n_screw_v])
                    rotate([0, 90, 0]) cylinder(d = hole(screw_d), h = t + 2, $fn = 24);
        // outlet ports, obround, kerf-corrected like the holes
        if (name == "back")
            for (x = hang_x)
                translate([x, Y - t - 1, port_z]) rotate([-90, 0, 0])
                    hull() for (s = [-1, 1]) translate([s * port_dx / 2, 0, 0])
                        cylinder(d = hole(port_d), h = t + 2, $fn = 48);
        // feeder case screw holes
        if (name == "back")
            for (x = hang_x, s = [-1, 1])
                translate([x + s * case_dx / 2, Y - t - 1, case_z]) rotate([-90, 0, 0])
                    cylinder(d = hole(screw_d2), h = t + 2, $fn = 24);
        // cord hole for a possible heater, a PG13.5 gland closed on a rod stub until then:
        // above the left flat spare, below the feeder, clear of everything
        if (name == "back")
            translate([cord_xz[0], Y - t - 1, cord_xz[1]]) rotate([-90, 0, 0]) cylinder(d = hole(cord_d), h = t + 2, $fn = 64);
        // feeder insert openings, rounded corners, kerf-corrected like the holes
        if (name == "top")
            for (x = hang_x)
                translate([x, hang_y, Z - t - 1]) linear_extrude(t + 2)
                    offset(r = hang_r) square(hang_wh + [1, 1] * (kerf - hole_kerf - 2 * hang_r), center = true);
        // door mounts (2026-11-04_door_mounts.scad), door flipped: hinge at the bottom, latches at
        // the top. Top panel = saddles, bottom panel = loops: 2 M3 each behind the 1010 member,
        // with nylock nuts inside the box.
        if (name == "top")
            for (lx = [X / 4, 3 * X / 4], sx = [-15, 15])
                translate([lx + sx, 17, Z - t - 1]) cylinder(d = hole(3.4), h = t + 2, $fn = 24);
        if (name == "bottom")
            for (lx = [X / 4, 3 * X / 4], sx = [-15, 15])
                translate([lx + sx, 32, -1]) cylinder(d = hole(3.4), h = t + 2, $fn = 24);
        if (name == "top")   // open through the back edge, over the back panel's solid tab
            for (x = hang_x)
                box([[x - hang_wh[0] / 2, x + hang_wh[0] / 2], [hang_y, Y + 1], [Z - t - 1, Z + 1]]);
    }
}

function cord_hole() = [cord_d, cord_xz];
function shell_dims() = [X, Y, Z, t, ext, ext_h, ext_v];   // for the assembly's checks and cut list

module frame3d() {
    for (z = [t, Z - t - ext]) translate([t, 0, z]) cube([ext_h, ext, ext]);
    for (x = [t, X - t - ext]) translate([x, 0, t + ext]) cube([ext, ext, ext_v]);
}

// door (2026-11-04, flipped mounting): a plain 640 x 258 panel, no holes. Its outside 1010
// frame (2 x 640 + 2 x 238) is bonded on with VHB; the top hooks and bottom latch catches
// mount to that frame (2026-11-04_door_mounts.scad).
module door2d() { square([X, Z]); }
module door_cut() { offset(delta = kerf / 2) door2d(); }

// flat outline of a shell panel, rotated into the xy plane
module panel2d(name) {
    offset(delta = kerf / 2) projection()
        if (name == "bottom" || name == "top") panel3d(name);
        else if (name == "back") rotate([90, 0, 0]) panel3d(name);
        else rotate([0, 90, 0]) panel3d(name);
}

module assembly() {
    color([0.80, 0.88, 1.0, 0.45]) for (p = ["bottom", "top", "back"]) panel3d(p);
    color([0.70, 0.80, 0.95, 0.55]) for (p = ["left", "right"]) panel3d(p);
    color("silver") frame3d();
    color([0.85, 0.9, 1.0, 0.3]) translate([0, -foam, 0]) rotate([90, 0, 0])
        linear_extrude(t) door2d();
}

if (solid != "") panel3d(solid);
else if (part == "assembly") assembly();
else if (part == "door") door_cut();
else panel2d(part);

echo(str("shell ", X, " x ", Y, " x ", Z, ", door ", t, " in front; t = ", t,
         "; clear opening ", ext_h - 2 * ext, " x ", ext_v));
echo(str("outlet ports ", port_dx + port_d, " x ", port_d, " at z ", port_z, ", x ", hang_x,
         "; case screws ", case_dx, " apart at z ", case_z, "; feeder openings ", hang_wh, " at x ", hang_x,
         ", y ", hang_y, " (y ", hang_y - hang_wh[1] / 2, " to ", hang_y + hang_wh[1] / 2,
         "; back joint at ", Y - t, ")"));
echo(str("extrusion cut list: 2 x ", ext_h, ", 2 x ", ext_v,
         " (one of each per 1000 mm stick, ", 1000 - ext_h - ext_v, " left over)"));
