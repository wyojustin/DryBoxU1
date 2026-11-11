// 2026-11-04: the roller on its own, lying along x. view = "iso" | "section" (cut along the axis).
use <2026-10-30_dry_box_cradle.scad>
view = "iso";
rotate([0, 90, 0])
    if (view == "iso") color("steelblue") roller();
    else color("steelblue") difference() { roller(); translate([-50, 0, -1]) cube([100, 50, 100]); }
