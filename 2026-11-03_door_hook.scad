// 2026-11-03: door bottom hook. Two per door, screwed to the door's inner face near the
// bottom edge. The hook reaches over the shell's bottom 1010 frame member and drops behind
// it; the door goes on bottom first (tilted out, hooks down behind the member), then swings
// shut and the two knob latches at the top pull it in. The hook's leg bears on the member's
// back face and holds the bottom edge with the foam at its 2.1 mm compressed thickness.
// The leg's bearing face is a wedge: lead mm of extra room at its tip so it drops in easily,
// closing to the design reach where the arm sits on the member, so lowering the door onto
// the hooks draws its bottom edge in. The door's weight hangs on the arm (no gap above the
// member), which seats the wedge.
// Profile in (y, z) of the box: y = 0 is the shell's front face (frame front), z = 0 the
// shell's bottom; extruded along x. Print on its side (the profile flat on the bed), PLA,
// 4 walls, 40 %, no supports. Units mm.

t       = 5.8;           // acrylic (door, and the shell's bottom panel)
ext     = 10;            // 1010
foam    = 2.1;           // compressed seal: the door's inner face sits at y = -foam
width   = 30;            // along x
wall    = 4;
clr     = 0;             // arm rests on the member's top face (the door hangs on it)
lead    = 3;             // wedge: extra room at the leg tip
door_y  = -foam;         // door inner face
mem_top = t + ext;       // bottom frame member: z t..t+ext, y 0..ext
leg_y   = ext;           // leg bears on the member's back face (y = ext)
leg_bot = t + 2.5;       // leg stops 2.5 above the floor panel
base_z  = [mem_top + clr, mem_top + clr + 26];   // base plate on the door, above the member
screw_d = 3.4;           // M3 through the door into nut traps
screw_z = [base_z[0] + wall + 6, base_z[1] - 5];
nut_af  = 5.6; nut_h = 2.6;

module profile() {
    // base plate against the door
    translate([door_y, base_z[0]]) square([wall, base_z[1] - base_z[0]]);
    // arm over the member
    translate([door_y, base_z[0]]) square([leg_y + wall - door_y, wall]);
    // leg down behind the member, bearing face wedged: leg_y at the arm, leg_y + lead at the tip
    polygon([[leg_y, base_z[0]], [leg_y + wall, base_z[0] + wall], [leg_y + wall + lead / 2, leg_bot],
             [leg_y + lead, leg_bot]]);
}

difference() {
    rotate([90, 0, 90]) linear_extrude(width) profile();   // profile (y, z) -> box axes
    for (x = [width / 4, 3 * width / 4], z = [screw_z[1]]) {
        translate([x, door_y - 1, z]) rotate([-90, 0, 0]) cylinder(d = screw_d, h = wall + 2, $fn = 24);
        translate([x, door_y + wall - nut_h, z]) rotate([-90, 0, 0]) cylinder(d = nut_af / cos(30), h = nut_h + 1, $fn = 6);
    }
}

echo(str("hook ", width, " wide; reach ", leg_y - door_y, " at the arm, ", leg_y + lead - door_y,
         " at the tip; leg tip back face ", leg_y + wall + lead / 2, " (floor rail at 20); screws at z ", screw_z[1]));
