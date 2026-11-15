// 2026-11-14: tapered D-pull for the door, after Justin's red cart handle: the outer ends slope in
// at 45 degrees from the frame to the grip, and the 2 M3 go in through those slopes, square to the
// frame, like the red one. 10 mm tall to match the 1010 door frame (the red one is for 2020).
// Justin: 120 max along the frame, 65 opening, screws 100 apart. With 45 degree ends that fixes
// the depth: the grip face (base - 2 dep) must hold the 65 opening plus 2 legs, so dep <= ~21.
// The top member's slot nuts are not captured, so they slide to the 100 spacing.
// Printed flat, this profile on the bed. Units mm.
// Profile in (x, y): y = 0 on the frame's outer face, grip face at y = -dep.

base  = 120;              // along the frame (max, Justin)
dep   = 21;               // out from the frame
face  = base - 2 * dep;   // 45-degree ends: 78
h     = 10;               // = 1010 member
bar   = 8;                // grip thickness: leaves dep - bar = 13 for the fingers
op    = 65;               // finger opening (Justin)
sc    = 100;              // screws, on the slopes (Justin)
floor_t = 4;              // plastic under the screw head
r_out = 3; r_in = 4;

module profile() difference() {
    offset(r = r_out, $fn = 32) offset(delta = -r_out)
        polygon([[-base / 2 - 2 * r_out, 2 * r_out], [base / 2 + 2 * r_out, 2 * r_out], [face / 2, -dep], [-face / 2, -dep]]);   // runs past the frame, clipped below: sharp back corners
    offset(r = r_in, $fn = 32) offset(delta = -r_in) translate([-op / 2, -dep + bar]) square([op, dep - bar + 10]);
    translate([-base, 0]) square([2 * base, 20]);          // back flat on the frame
}
module handle() difference() {
    linear_extrude(h) profile();
    for (m = [-1, 1]) translate([m * sc / 2, 1, h / 2]) rotate([90, 0, 0]) {
        cylinder(d = 3.4, h = dep + 2, $fn = 24);
        translate([0, 0, 1 + floor_t]) cylinder(d = 6.2, h = dep, $fn = 32);   // head counterbore, opens on the slope
    }
}
handle();
echo(str("handle base ", base, ", face ", face, ", out ", dep, ", tall ", h, ", screws ", sc,
         " apart on the slopes (slope ", base / 2 - sc / 2, " out there), opening ", op, " x ", dep - bar, " deep"));
