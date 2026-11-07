// 2026-11-04: quick side sketch to confirm the J-hook idea (front at left, y into the box).
Z = 258; t = 5.8; ext = 10; foam = 2.1;
ri = 4.3; ro = 10;            // hook curve: inner radius hugs the 8 mm bar, outer radius 10
bar = [10, Z + 10.5];         // bar centre (y, z): over the top 1010 member
module slab(y0, y1, z0, z1) translate([y0, z0]) square([y1 - y0, z1 - z0]);
color([0.80, 0.88, 1.0]) slab(0, 40, Z - t, Z);                    // top panel
color([0.75, 0.76, 0.78]) slab(0, ext, Z - t - ext, Z - t);       // top 1010 member
color([0.25, 0.25, 0.25]) slab(-foam, 0, Z - 18, Z);               // foam
color([0.85, 0.92, 1.0]) slab(-foam - t, -foam, Z - 30, Z);        // door
color([0.70, 0.71, 0.73]) slab(-foam - t - ext, -foam - t, Z - ext, Z);   // door frame
color([0.95, 0.55, 0.1, 0.35]) slab(-1, 24, Z, Z + 22);            // loop cheek (behind the hook)
color([0.55, 0.55, 0.58]) translate(bar) circle(d = 8, $fn = 48);  // 8 mm rod bar
color([0.2, 0.2, 0.22]) {                                          // hook
    slab(-foam - t - ext, bar[0], Z, bar[1] - ri);                 // lower arm from the door frame
    translate(bar) difference() { circle(r = ro, $fn = 64); circle(r = ri, $fn = 48); translate([-ro - 1, -ro - 1]) square([ro + 1, 2 * ro + 2]); }  // 180 deg curve behind the bar
    slab(bar[0] - 8, bar[0], bar[1] + ri, bar[1] + ro);            // upper arm over the bar
}
