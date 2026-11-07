// 2026-11-03: top panel with both feeder inserts (v9) installed,
// cable slots toward the back edge. Units mm, panels-file axes.
t = 5.8; Z = 258; X = 640;
pitch  = (X - 2 * t) / 7;
hang_x = [t + pitch, X - t - pitch];
hang_y = (430 - t) - 2.1 + 0.2 - 33;   // 389.3, as in the panels file

use <2026-10-30_dry_box_panels.scad>

color([0.75, 0.85, 1.0]) render() panel3d("top");
for (x = hang_x)
    color([0.95, 0.55, 0.1]) translate([x, hang_y, Z - t]) rotate([0, 0, 180])
        import("stl/2026-11-03_feeder_insert_v11.stl");
