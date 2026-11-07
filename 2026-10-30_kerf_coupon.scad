// 2026-10-30: kerf and fit test for the dry box finger joints, cut from the same 6 mm sheet.
// Four A/B pairs, each with a different kerf allowance; each pair forms one corner with
// the box's 30 mm fingers. Dots identify the pair: 1 dot = kerfs[0], 2 dots = kerfs[1], ...
// A pieces also test the M3 frame screw hole 5 mm from an edge; B pieces test the
// PC4-M10 feed fitting hole. Put the winning kerf into 2026-10-30_dry_box_panels.scad.
// Units mm.

t      = 5.65;                     // sheet thickness, same as the box file
kerfs  = [0.10, 0.15, 0.20, 0.25];
L      = 90;                       // joint length: 3 segments of 30, like the box
W      = 40;                       // piece width away from the joint
seg    = L / 3;
screw_d = 3.4;
fit_d   = 10.5;
dot_d   = 2.5;
gap     = 10;

// A keeps the two end fingers, B keeps the middle one
module piece(owner_even, k, n_dots) {
    offset(delta = k / 2) difference() {
        square([L, W]);
        for (i = [0 : 2]) if ((i % 2 == 0) != owner_even)
            translate([i * seg, W - t]) square([seg, t + 1]);
        for (d = [0 : n_dots - 1])
            translate([10 + d * 6, 12]) circle(d = dot_d, $fn = 16);
        if (owner_even) translate([L - 15, 5]) circle(d = screw_d, $fn = 24);
        else            translate([L - 18, 15]) circle(d = fit_d, $fn = 48);
    }
}

// one pair per row (A left, B right), sized to fit the 300 x 250 offcut
for (i = [0 : len(kerfs) - 1]) {
    translate([0, i * (W + gap)])          piece(true,  kerfs[i], i + 1);
    translate([L + gap, i * (W + gap)])    piece(false, kerfs[i], i + 1);
}

echo(str("kerf allowances by dot count: ", kerfs, "; layout ", 2 * L + gap,
         " x ", len(kerfs) * (W + gap) - gap, " mm"));
