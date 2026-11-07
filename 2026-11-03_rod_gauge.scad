// 2026-11-03: rod fit gauge, round 2. The 8.05 / 8.15 / 8.25 holes in the first gauge were
// all too tight for the 8 mm rod (holes printed horizontal come out small). Same plate as
// the cradle's end plates (4.8 thick, standing on edge so the holes print horizontal, as in
// the cradle). Dots under each hole count the candidate: 1 dot = first value, ... Units mm.

rod   = [8.35, 8.45, 8.55, 8.65];
pitch = 16;
plate = [(len(rod) - 1) * pitch + 20, 22, 4.8];

rotate([90, 0, 0]) difference() {
    cube(plate);
    for (i = [0 : len(rod) - 1]) translate([10 + i * pitch, 13, -1]) {
        cylinder(d = rod[i], h = plate[2] + 2, $fn = 48);
        for (k = [0 : i]) translate([(k - i / 2) * 2.6, -9, 0]) cylinder(d = 1.4, h = plate[2] + 2, $fn = 12);
    }
}
echo(str("rod gauge ", rod, " (1 to 4 dots)"));
