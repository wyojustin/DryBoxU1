// 2026-11-02: concept view, U1 feeders hung from the top panel in the upper back corners.
// The feeder is a placeholder block (about 55 wide, 50 tall, 65 long, guessed from photos);
// the hanger is a plate with the feeder's clip interface, not designed yet. Spools sit on the
// cradles at an approximate depth. Units mm, axes as in the panels file.

use <2026-10-30_dry_box_panels.scad>

t = 5.8; X = 640; Z = 258; Y = 385 - t;
pitch   = (X - 2 * t) / 7;
spool_d = 210; spool_w = 65;
spool_y = 210;                       // approximate spool axis depth
spool_z = t + 119.7;                 // from the cradle file (210 spool)
feed_x  = [t + pitch, X - t - pitch];
fd      = [55, 65, 50];              // feeder: x, y (filament direction), z
hanger_t = 4;
top_in  = Z - t;
feeder_y1 = Y - t - 8;               // outlet face 8 mm in front of the back wall
outlet_dx = 24;
outlet_z  = top_in - hanger_t - fd[2] / 2;

module feeder() {   // inlets at -y, outlets at +y, clip face up
    color("white") translate([-fd[0] / 2, -fd[1], -fd[2]]) cube([fd[0], fd[1] * 0.55, fd[2]]);
    color([0.15, 0.15, 0.17]) translate([-fd[0] / 2, -fd[1] * 0.45, -fd[2]]) cube([fd[0], fd[1] * 0.45, fd[2]]);
}

module hanger() {
    color([0.95, 0.55, 0.1]) difference() {
        translate([-fd[0] / 2 - 6, -fd[1] - 4, 0]) cube([fd[0] + 12, fd[1] + 12, hanger_t]);
    }
    // cable channel back to the slot in the back wall
    color([0.95, 0.55, 0.1]) translate([-6, 0, -6]) cube([12, Y - t - feeder_y1, 6 + hanger_t]);
}


for (i = [0 : 6]) {
    x = t + pitch * (i + 0.5);
    color(i < 2 || i > 4 ? "tomato" : "burlywood") translate([x, spool_y, spool_z]) rotate([0, 90, 0])
        difference() {
            cylinder(d = spool_d, h = spool_w, center = true, $fn = 72);
            cylinder(d = 55, h = spool_w + 2, center = true, $fn = 36);
        }
}

for (k = [0 : 1]) {
    fx = feed_x[k];
    translate([fx, feeder_y1, top_in - hanger_t]) feeder();
    translate([fx, feeder_y1, top_in - hanger_t]) hanger();
    // filament from the two spools' tops to the inlets
    for (j = [0 : 1]) {
        sx = t + pitch * (2 * k * 2.5 + j + 0.5);   // slots 0, 1 and 5, 6
        color("red") hull() {
            translate([sx, spool_y + 20, spool_z + spool_d / 2 - 2]) sphere(d = 1.75, $fn = 8);
            translate([fx + (j - 0.5) * outlet_dx, feeder_y1 - fd[1], outlet_z]) sphere(d = 1.75, $fn = 8);
        }
        // PTFE stub from each outlet through the back wall
        color([0.9, 0.95, 1.0]) translate([fx + (j - 0.5) * outlet_dx, feeder_y1, outlet_z])
            rotate([-90, 0, 0]) cylinder(d = 4, h = 60, $fn = 16);
    }
}

// transparent parts last (OpenCSG draws in order); top panel left off as a cutaway
color("silver") frame3d();
color([0.80, 0.88, 1.0, 0.35]) for (p = ["bottom", "back", "left", "right"]) panel3d(p);
