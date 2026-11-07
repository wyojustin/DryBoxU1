// 2026-11-04: side profile through the centre of a top loop and J-hook (front at left, y into
// the box, z up): top panel, top 1010 member, foam, door, door frame, loop cheek (shaded,
// behind the hook), 8 mm bar, hook. Closed position.
use <2026-11-04_door_mounts.scad>
Z = 258; t = 5.8; ext = 10; foam = 2.1;
module slab(y0, y1, z0, z1) translate([y0, z0]) square([y1 - y0, z1 - z0]);
color([0.80, 0.88, 1.0]) slab(0, 40, Z - t, Z);
color([0.75, 0.76, 0.78]) slab(0, ext, Z - t - ext, Z - t);
color([0.25, 0.25, 0.25]) slab(-foam, 0, Z - 18, Z);
color([0.85, 0.92, 1.0]) slab(-foam - t, -foam, Z - 30, Z);
color([0.70, 0.71, 0.73]) slab(-foam - t - ext, -foam - t, Z - ext, Z);
color([0.95, 0.55, 0.1]) translate([0, 0, -1]) render() loop_side2d();     // loop cheek (behind)
color([0.55, 0.55, 0.58]) translate([14.5, Z + 10, 1]) circle(d = 8, $fn = 48);   // bar
color([0.2, 0.2, 0.22]) render() hook_profile();   // render(): preview draws the 2D difference wrong
