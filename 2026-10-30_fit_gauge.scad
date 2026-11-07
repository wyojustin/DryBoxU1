// 2026-10-30: fit gauge for the cradle rollers, printed instead of a full roller.
// Top row: 608 bearing pockets (bear_od candidates), each a short roller end, 7.5 mm deep.
// Bottom row: 8 mm rod holes (rod_d candidates) in a 4.8 mm plate standing on edge.
// Notches on the edge count the candidate: 1 notch = first value, 2 = second, ...
// Put the winners into bear_od and rod_d in 2026-10-30_dry_box_cradle.scad. Units mm.

bear = [22.05, 22.15, 22.25];
rod  = [8.05, 8.15, 8.25];
roll_od = 28;
pitch   = 34;

module notches(n, r) {
    for (i = [0 : n - 1]) rotate(90 + (i - (n - 1) / 2) * 15)
        translate([r, 0, -1]) cylinder(d = 2, h = 20, $fn = 12);
}

// bearing pockets: a roller end with the real wall, open at the top
for (i = [0 : len(bear) - 1]) translate([i * pitch, 0, 0]) difference() {
    cylinder(d = roll_od, h = 8, $fn = 64);
    translate([0, 0, 0.5]) cylinder(d = bear[i], h = 8, $fn = 64);
    translate([0, 0, -1]) cylinder(d = 12, h = 3, $fn = 32);   // push-out hole
    notches(i + 1, roll_od / 2);
}

// rod holes in a plate as thick as the cradle plates, standing on edge so the holes print
// horizontal, as they do in the cradle's upright end plates
translate([-roll_od / 2, -25, 0]) rotate([90, 0, 0]) difference() {
    cube([(len(rod) - 1) * pitch + roll_od, 22, 4.8]);
    for (i = [0 : len(rod) - 1]) translate([roll_od / 2 + i * pitch, 11, -1]) {
        cylinder(d = rod[i], h = 7, $fn = 32);
        for (k = [0 : i]) translate([(k - i / 2) * 3, -9, 0]) cylinder(d = 1.6, h = 7, $fn = 12);
    }
}

echo(str("bearing pockets ", bear, " (1, 2, 3 notches); rod holes ", rod, " (1, 2, 3 dots)"));
