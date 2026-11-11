// 2026-11-05: side view (front at left) of the filament path from a spinning spool to the feeder
// inlet as the spool empties (wrap radius 105, 80, 55), against 2 spares on edge behind the
// rollers. The filament leaves tangent to the wrap, so its line drops as the spool runs down.
t = 5.8; ax = [115, 125.5]; inlet = [360.3, 212.2]; top_in = 252.2; back_in = 424.2;
module seg(a, b, w = 1.6) hull() { translate(a) circle(d = w, $fn = 12); translate(b) circle(d = w, $fn = 12); }
function tang(r) = let (d = inlet - ax, L = norm(d), th = atan2(d[1], d[0]) + acos(r / L))
    ax + r * [cos(th), sin(th)];
color([0.85, 0.92, 1.0]) { translate([0, 0]) square([back_in + t, t]); translate([0, top_in]) square([back_in + t, t]); translate([back_in, 0]) square([t, top_in + t]); }
color([1.0, 0.75, 0.68]) translate(ax) circle(r = 105, $fn = 96);
color([0.85, 0.75, 0.55]) for (y = [220.5, 286.5]) translate([y, t]) square([65, 210]);
color([0.2, 0.2, 0.22]) translate([360.3, top_in - 55]) square([61.8, 55]);
for (r = [105, 80, 55]) { color([0.9, 0.1, 0.1]) translate([0, 0, 1]) seg(tang(r), inlet);
    color([0.9, 0.1, 0.1]) translate(ax) translate([0, 0, 1]) render() difference() { circle(r = r + 0.5, $fn = 96); circle(r = r - 0.5, $fn = 96); } }
for (r = [105, 80, 55]) { p = tang(r); s = (inlet[1] - p[1]) / (inlet[0] - p[0]);
    echo(str("r ", r, ": tangent point ", p, ", filament z at y 220.5 ", p[1] + s * (220.5 - p[0]), ", at y 351.5 ", p[1] + s * (351.5 - p[0]))); }
