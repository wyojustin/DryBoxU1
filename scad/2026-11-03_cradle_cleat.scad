// 2026-11-03: front floor cleat for the cradle row. Two per box, one at each end of the row,
// stuck to the floor (VHB tape or RTV) against the front of the end cradles. With the
// desiccant tray as the back stop, the row stays square to the door and still lifts out.
// Plain block: the cradles sit flat on the floor, so nothing can tuck under them. Print flat
// on its base, PLA, no supports.
// Axes: x along the row, y toward the back (+y touches the cradles), z up. Units mm.

len_x  = 40;     // spans the end cradle's plate (4.8) and part of its front rail
dep_y  = 12;
ht_z   = 10;     // stays below the spool rims (lowest ~14.7 above the floor)
chamf  = 3;

difference() {
    cube([len_x, dep_y, ht_z]);
    // chamfer the top front edge (the side you see through the door)
    translate([-1, 0, ht_z - chamf]) rotate([45, 0, 0]) cube([len_x + 2, chamf * 1.5, chamf * 1.5]);
}

echo(str("cleat ", len_x, " x ", dep_y, " x ", ht_z));
