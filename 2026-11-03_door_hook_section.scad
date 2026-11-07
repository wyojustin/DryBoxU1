// 2026-11-03: side section through a door bottom hook (looking along x): shell bottom
// panel, bottom 1010 frame member, foam, door and its outside 1010 frame, hook, floor rail.
t = 5.8; ext = 10; foam = 2.1;
w = 30;   // section slab along x
color([0.80, 0.88, 1.0]) translate([0, 0, 0]) cube([w, 120, t]);                       // shell bottom panel
color([0.75, 0.76, 0.78]) translate([0, 0, t]) cube([w, ext, ext]);                     // bottom frame member
color([0.75, 0.76, 0.78]) translate([0, 20, t]) cube([w, ext, ext]);                    // floor rail
color([0.25, 0.25, 0.25]) translate([0, -foam, 0.5]) cube([w, foam, 14]);              // foam
color([0.85, 0.92, 1.0]) translate([0, -foam - t, 0]) cube([w, t, 70]);                // door acrylic
color([0.75, 0.76, 0.78]) translate([0, -foam - t - ext, 0]) cube([w, ext, ext]);      // door frame, bottom
color([0.2, 0.2, 0.22]) import("stl/2026-11-03_door_hook.stl");
