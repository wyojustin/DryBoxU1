// 2026-11-04: U1 feeder insert v11, RELEASED (firm hold, stop tab perfect; a bit stiff to remove, friction). Drops into the 72 x 66 opening in the dry
// box's top panel (flange on the top face, RTV seal); the feeder hangs under it on its own
// hooks, mounting face up, outlets toward the back wall. Copies the printer's side-panel
// windows (measured on the printer), with the panel thickness the hooks expect under each
// lip: black hooks (outlet end) gap 5.0 -> 4.8 seat; white hooks (inlet end) gap 6.7 -> 6.5.
// v1 -> v2: windows from the printer panel instead of photo estimates (pairs 38.35 and
// 38.5 apart, black-white 27.0 apart, black 9 x 8.5, white 11.8 x 8, along x across);
// latch notch copied from the printer (stepped, one side only); cable slot moved to the
// inlet end like the printer: the cable lies in the feeder's center channel to its socket.
// v2 -> v3: cable slot at the front (inlet) end, latch notch at the back (outlet) end beyond
// the black windows; 20 mm ribbon groove in the underside, the full body length, leading to
// the cable slot; slot shortened to 6 along y so the layout fits the 66 mm opening.
// v3 -> v4: sealed: only the cable slot goes through. Hook windows are blind cavities from
// below (window up past the lip, then the lip's landing undercut at the seat height), capped
// by a flat top (flange 5.9 thick); latch notch on both sides, blind, 4.5 deep from below.
// v4 -> v5: white windows moved beside the latch notch (back), black windows beside the cable
// slot (front), as on the printer (the notch sits next to the wide 11.8 window); the lip
// undercut now runs lip_land both ways along y, so the hooks catch whichever way they slide.
// v5 -> v6: latch notch flipped, its wide (6) end opens toward the cable slot (front).
// v6 -> v7 (after the v6 test fit, which worked but was tight): white windows 0.5 bigger
// each way, centers kept; all hook windows and notches shift 2.6 toward the cable-slot end
// so the feeder's outlet face lands flush with the insert edge (the back wall side).
// v7 -> v8: the cable slot shifts the same 2.6, so it now opens through the body's back
// edge (the top panel's opening edge closes it below the flange).
// v10 -> v11: the two stop-tab notches 0.5 further apart (0.25 outward each), easier release.
// v9 -> v10 (v9 test fit): stop-tab notches moved 1.5 toward the middle and 0.5 away from the
// cable outlet, so the latch tab is preloaded while sliding and relaxes when fully engaged.
// v8 -> v9: the top panel's opening now runs out through its back edge over one solid
// back-panel tab, so the insert body extends back to the back panel's inner face (less
// clearance) and the flange back to its outer face; the cable slot opens through the
// lengthened body's back edge against the back panel.
// Lip thicknesses are photo estimates (black ~1.9, white ~3.1); cavities leave room.
// Notch offset is scaled from a photo (about +-1 mm): check on the test.
// Install: plug the cable into the feeder, lay it in the center channel, feed the far plug up
// through the cable slot, hooks in, slide the feeder toward its outlets until it latches.
// Print flange down (the feeder face prints as the smooth top), PLA, 0.2 mm, 4 walls,
// 15 % infill for the test, no supports. Units mm.
// Axes: x across the feeder, y along it (+y = outlet end = back wall), z up; z = 0 is the
// feeder face, flush with the acrylic's underside. Seen from below (from the feeder) this
// matches the printer panel seen from outside, with the printer's front at +y.

t        = 5.8;          // acrylic, top panel
open     = [72, 66];     // opening in the top panel (x, y), corners r 3
open_r   = 3;
clr      = 0.2;          // body to opening, each side
flange_w = 8;

body_y   = open[1] / 2 - clr;   // body half-length, 32.8
end_wall = 1.2;
cable_slot = [25, 6];    // across x, along y; passes the 20 x 5 plug
cable_gap  = 2.0;        // slot to the black windows' front edge
shift    = -2.6;         // v7: windows and notches toward the cable-slot end
y_black0 = -body_y + end_wall + cable_slot[1] + cable_gap + 9.0 / 2;   // v6 position
y_black  = y_black0 + shift;
y_white  = y_black + 27.0;
white_grow = 0.5;        // v7: white windows were tight

// windows: [x center, y center, size along y, size across x, lip seat, cavity top]
WIN = [
    [-38.35 / 2, y_black,  9.0, 8.5, 4.8,  8.0],
    [ 38.35 / 2, y_black,  9.0, 8.5, 4.8,  8.0],
    [-38.5 / 2,  y_white, 11.8 + white_grow, 8.0 + white_grow, 6.5, 10.5],
    [ 38.5 / 2,  y_white, 11.8 + white_grow, 8.0 + white_grow, 6.5, 10.5],
];
lip_land = 4.5;          // undercut extends this far past each window, both ways along y
cap      = 1.2;          // boss wall over and around each cavity

// latch notch on both sides (blind, notch_d deep from below), beyond the white window toward the back: inner edge straight,
// outer edge stepped, 6 wide at the front (open toward the cable slot) for notch_step,
// then 4.2 wide; 11.2 long
notch_gap  = 5.2 + 0.5;  // white window back edge to notch (v10: +0.5 away from the cable outlet)
notch_len  = 11.2;
notch_step = 4.5;
notch_w    = [4.2, 6.0];
notch_in   = 38.5 / 2 + 1.35 - 1.5 + 0.25;   // inner edge from the centerline (v10: 1.5 in; v11: 0.25 back out)
notch_d    = 4.5;               // latch block sticks up ~3.5

groove_w = 20;           // ribbon groove in the underside (15-pin 1.25 mm ribbon ~19 wide)
groove_d = 1.5;

// flat top over the tallest cavity, so the insert still prints flange down on a flat face
T = max([for (w = WIN) w[5]]) + cap;
// back (-y, cable-slot) end: the outlet face is flush with the v8 body edge (-body_y), 2.1
// (foam) in front of the back panel's inner face; the panel is 5.8 thick
foam    = 2.1;
body_bk = -body_y - foam + clr;     // body back edge, clr short of the back panel
fl_bk   = body_bk - clr - t;     // flange back edge, flush with the back panel's outside

module rrect(size, r) { offset(r = r) square(size - [2, 2] * r, center = true); }
module box(x0, x1, y0, y1, z0, z1) { translate([x0, y0, z0]) cube([x1 - x0, y1 - y0, z1 - z0]); }

y_black_fr = y_black - 9.0 / 2;    // black windows' front edge (sets the cable slot)
y_white_bk = y_white + 11.8 / 2;   // white windows' nominal back edge (sets the notch)

difference() {
    union() {
        linear_extrude(t) rrect(open - [2, 2] * clr, open_r);
        box(-(open[0] / 2 - clr), open[0] / 2 - clr, body_bk, 0, 0, t);   // body to the back wall
        translate([0, 0, t]) linear_extrude(T - t) intersection() {
            rrect(open + [2, 2] * flange_w, open_r + 2);
            translate([-100, fl_bk]) square([200, 200]);
        }
    }
    for (w = WIN) {
        x0 = w[0] - w[3] / 2; x1 = w[0] + w[3] / 2;
        y0 = w[1] - w[2] / 2; y1 = w[1] + w[2] / 2;
        box(x0, x1, y0, y1, -1, w[5]);
        // cavity above the lip seat, over the window and the lip's landing
        box(x0 - 1, x1 + 1, y0 - lip_land, y1 + lip_land, w[4], w[5]);
    }
    // latch notches, both sides, blind: wide end toward the front (cable slot)
    ny0 = y_white_bk + notch_gap;
    for (m = [0, 1]) mirror([m, 0, 0]) {
        box(-notch_in - notch_w[1], -notch_in, ny0, ny0 + notch_step, -1, notch_d);
        box(-notch_in - notch_w[0], -notch_in, ny0 + notch_step - 0.01, ny0 + notch_len, -1, notch_d);
    }
    // ribbon groove, full body length (stops inside the opening's footprint)
    box(-groove_w / 2, groove_w / 2, body_bk - 1, body_y + 1, -1, groove_d);
    // cable slot
    box(-cable_slot[0] / 2, cable_slot[0] / 2,
        body_bk - 1, y_black_fr - cable_gap, -1, T + 1);   // open through the back edge
}

echo(str("v11: back edge ", body_bk, ", flange back ", fl_bk, "; body ", open - [2, 2] * clr, ", flange ", open + [2, 2] * flange_w, " x ", T - t,
         "; cable slot y ", body_bk, " to ", y_black_fr - cable_gap,
         "; black y ", y_black, ", white y ", y_white, "; notch y ", y_white_bk + notch_gap,
         " to ", y_white_bk + notch_gap + notch_len, " (body edge +-", body_y, ")"));
