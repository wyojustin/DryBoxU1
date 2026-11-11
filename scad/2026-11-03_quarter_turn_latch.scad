// 2026-11-03: quarter-turn door latch on an M5 bolt (concept, 2 per door, top edge).
// An M5 bolt turns freely in a 5.5 mm hole in the door. Outside: a printed knob on the bolt
// head. Inside: a printed T-bar on the bolt's tip (captive M5 nut, its position on the
// thread sets the squeeze). A printed receiver hangs from the back slot of the shell's top
// 1010 member: the bar passes through its slot with the knob vertical, and a quarter turn
// carries it up two helical ramps (ramp_rise over 90 deg) on the receiver's back face,
// pulling the door in; a shallow notch at the end of each ramp holds it locked.
// part = "assembly" | "knob" | "bar" | "receiver"; turn = 0 (open) .. 90 (locked).
// Axes as the box: y = 0 the shell front face, door inner face at y = -foam, z up. Units mm.

part = "assembly";
turn = 90;

t = 5.8; ext = 10; foam = 2.1;
mem_z   = [258 - t - ext, 258 - t];      // top frame member, 242.2 .. 252.2
bolt_z  = mem_z[0] - 7;                  // bolt axis, 7 below the opening's top edge
door_y  = -foam;

// receiver
rc_front = 10.5;  rc_t = 4;              // plate y = 10.5 .. 14.5, just behind the member
slot     = [6, 17];                      // across, along the bar (the bar enters vertical)
ramp_r   = [5, 11];                      // ramp annulus radii
ramp_rise = 3;                           // pull-in over the quarter turn
notch    = 0.6;

// bar
bar      = [17, 5, 4];                   // length, width, thickness (along y)
bar_y0   = rc_front + rc_t + ramp_rise - 0.2;   // bar front face when locked
nut_af = 8; nut_h = 4;

// ---------- parts ----------
module knob() {
    difference() {
        union() {
            cylinder(d = 24, h = 6, $fn = 48);
            translate([0, 0, 6]) cylinder(d1 = 24, d2 = 20, h = 6, $fn = 48);
            for (a = [0, 180]) rotate(a) translate([0, -2.5, 0]) cube([16, 5, 12]);   // wings
        }
        translate([0, 0, -1]) cylinder(d = 5.5, h = 20, $fn = 24);
        translate([0, 0, 8]) cylinder(d = 8.6 / cos(30), h = 5, $fn = 6);   // M5 hex head
    }
}

module bar() {
    difference() {
        translate([-bar[0] / 2, -bar[1] / 2, 0]) cube(bar);
        translate([0, 0, -1]) cylinder(d = 5.5, h = bar[2] + 2, $fn = 24);
        translate([0, 0, bar[2] - nut_h + 0.01]) cylinder(d = nut_af / cos(30), h = nut_h, $fn = 6);
    }
}

// receiver in its own frame: x across, local z = box y (from rc_front), local y = box z
// (0 = bolt axis); mount tab goes up behind the member to its back slot
module ramp() {   // one 90 deg helical ramp on the back face, rising ramp_rise, notch at the end
    for (i = [0 : 17]) {
        a0 = i * 5; a1 = a0 + 5;
        h = rc_t + ramp_rise * (i + 1) / 18 - (i == 17 ? notch : 0);
        rotate(a0) rotate_extrude(angle = 5, $fn = 72) translate([ramp_r[0], 0]) square([ramp_r[1] - ramp_r[0], h]);
    }
}
module receiver() {
    difference() {
        union() {
            translate([-16, -14, 0]) cube([32, 28, rc_t]);               // plate
            for (a = [0, 180]) rotate(a + 90) ramp();                    // two ramps, 180 apart
            translate([-10, 14 - 0.01, 0]) cube([20, mem_z[1] - bolt_z - 14 - 1, rc_t]);   // tab up
        }
        // bar slot (vertical) and bolt clearance
        translate([-slot[0] / 2, -slot[1] / 2, -1]) cube([slot[0], slot[1], 20]);
        // M3 into the member's back-slot T-nut
        translate([0, (mem_z[0] + mem_z[1]) / 2 - bolt_z, -1]) cylinder(d = 3.4, h = 20, $fn = 24);
    }
}

// ---------- assembly ----------
module assembly() {
    // door and top member, for context
    color([0.85, 0.92, 1.0, 0.5]) translate([-40, door_y - t, bolt_z - 30]) cube([80, t, 60]);
    color([0.75, 0.76, 0.78]) translate([-40, 0, mem_z[0]]) cube([80, ext, ext]);
    // receiver: hangs behind the member, its plate at y = rc_front .. rc_front + rc_t
    color([0.95, 0.55, 0.1]) translate([0, rc_front, bolt_z]) rotate([-90, 0, 0]) mirror([0, 1, 0]) receiver();
    // bolt, knob, bar
    translate([0, 0, bolt_z]) rotate([0, turn, 0]) {
        color("silver") translate([0, door_y - t - 4, 0]) rotate([-90, 0, 0]) cylinder(d = 5, h = 30, $fn = 24);
        color([0.15, 0.15, 0.17]) translate([0, door_y - t, 0]) rotate([90, 0, 0]) knob();
        color([0.2, 0.4, 0.8]) translate([0, bar_y0, 0]) rotate([-90, 0, 0]) rotate(90) bar();
    }
}

if (part == "knob") knob();
else if (part == "bar") bar();
else if (part == "receiver") receiver();
else assembly();
