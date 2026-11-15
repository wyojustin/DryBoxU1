// 2026-11-11: tunnel glue-up jig, print 2. Sits on the tunnel floor between the walls, one near
// each end, while the solvent cement cures. Its width sets the walls 157 apart and its square
// sides hold them at 90 degrees to the floor; it stops 0.3 below the wall tops so the deck can
// be clamped down onto the walls (the jig keeps the walls from bowing in under the clamp).
// Chamfered edges at all 4 inside corners leave room for squeeze-out, so the jig never touches
// the wet joints and slides out the open end afterwards. The STL lies flat on its 157 x 75.7 face
// (the 157 and the square corners are in the bed plane, where the printer is most accurate), no supports.
// part = "jig" | "view" (2 jigs in the tunnel, deck lifted). Units mm.

use <2026-11-05_interior.scad>

part = "jig";

tn     = int_tun();                      // [tun_in, tun_w, tun_l, deck_l, wall_h]
tun_in = tn[0]; wall_h = tn[4];
t      = 5.8;
jig_w  = tun_in;                         // 157: sets the walls
jig_h  = wall_h - 0.3;                   // deck rests on the walls, not the jig
jig_d  = 30;                             // along the tunnel
rel    = 3;                              // squeeze-out chamfer at each inside corner
bar    = 10;                             // frame bar width (window in the middle saves filament)

module profile() difference() {
    polygon([[rel, 0], [jig_w - rel, 0], [jig_w, rel], [jig_w, jig_h - rel],
             [jig_w - rel, jig_h], [rel, jig_h], [0, jig_h - rel], [0, rel]]);
    translate([bar, bar]) offset(r = 4, $fn = 32) offset(delta = -4) square([jig_w - 2 * bar, jig_h - 2 * bar]);
}
module jig() rotate([90, 0, 0]) translate([0, 0, -jig_d]) linear_extrude(jig_d) profile();   // standing in the tunnel

if (part == "jig") linear_extrude(jig_d) profile();   // print orientation
else if (part == "view") {
    tun_w = tn[1]; tun_l = tn[2];
    color([0.80, 0.88, 1.0, 0.6]) cube([tun_w, tun_l, t]);                                  // floor
    for (x = [0, tun_w - t]) color([0.80, 0.88, 1.0, 0.6]) translate([x, 0, t]) cube([t, tun_l, wall_h]);
    color([0.85, 0.92, 1.0, 0.35]) translate([0, -5, t + wall_h + 40]) cube([tun_w, tn[3], t]);   // deck, lifted
    for (y = [20, tun_l - 20 - jig_d]) color("orange") translate([t, y, t]) jig();
}
echo(str("jig ", jig_w, " wide x ", jig_h, " tall x ", jig_d, " deep (walls ", wall_h, ")"));
