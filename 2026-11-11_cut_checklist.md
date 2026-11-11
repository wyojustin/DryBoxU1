# DryBoxU1 cut checklist (2026-11-11)

Everything that gets sawn or lasered, in order. Units mm. Lengths come from the `.scad` files
(`2026-11-03_dry_box_assembly.scad` prints them; copy in [`cut/2026-11-05_cut_list.txt`](cut/2026-11-05_cut_list.txt)).
Figures (in the history, commit 774f584): [rip plan](https://github.com/wyojustin/DryBoxU1/blob/774f584/renders/2026-11-11_rip_plan.png),
[cut sheets](https://github.com/wyojustin/DryBoxU1/blob/774f584/renders/2026-11-11_cut_sheets.png), [cut plan with tight spots](https://github.com/wyojustin/DryBoxU1/blob/774f584/renders/2026-11-11_cut_plan.png).

## 0. Before anything

- [ ] Safety glasses, hearing protection, dust mask.
- [ ] Lay a 910 edge of a sheet along the laser bed: it must lie flat over the full length (work area 915 x 458).
- [ ] Practice the circular saw's guide offset on scrap MDF (base plate edge to the near tooth).

## 1. Acrylic rips (circular saw, 60T blade)

Stock 603 x 910, 5.8 cast acrylic. Film stays on for sawing. Sheet on foam board, blade 3 to 5 below
it, guide clamped on the strip you keep, kerf (about 1.8) on the waste side. Every rip runs the full 910.

| | Sheet | Rip | Keep | Must be at least |
|---|---|---|---|---|
| [ ] | B (sheet 2 or 3) | 450 from a factory edge | 450 x 910, strip 1 (top + left) | 436 |
| [ ] | C (the other) | 450 from a factory edge | 450 x 910, strip 2 (bottom + right) | 436 |
| [ ] | A (sheet 4, the most even) | measured width / 2, kerf split | two ~300.6 x 910, strips 3 (back) and 4 (door) | 264 each |

- [ ] Measure each strip at both ends and the middle.
- [ ] Label each strip on the film: number, plus an arrow on the factory edge (the laser's y = 0).
- [ ] Keep the two 151 x 910 offcuts and the ~260 x 300 ends of strips 3 and 4 for interior parts.
- [ ] Sheet 1 stays whole (interior, see 5).

## 2. Laser: shell (peel the film first)

Job origin at the strip corner, factory edge on y = 0. Kerf 0.25 is built into the files.

| | Strip | File | Parts |
|---|---|---|---|
| [ ] | 1 | [`cut/2026-10-30_dry_box_strip1.svg`](cut/2026-10-30_dry_box_strip1.svg) | top + left |
| [ ] | 2 | [`cut/2026-10-30_dry_box_strip2.svg`](cut/2026-10-30_dry_box_strip2.svg) | bottom + right |
| [ ] | 3 | [`cut/2026-10-30_dry_box_strip3.svg`](cut/2026-10-30_dry_box_strip3.svg) | back (gland hole 19.8) |
| [ ] | 4 | [`cut/2026-10-30_dry_box_strip4.svg`](cut/2026-10-30_dry_box_strip4.svg) | door |
| [ ] | EVA | [`cut/2026-11-05_feeder_gasket.svg`](cut/2026-11-05_feeder_gasket.svg) | 2 feeder gaskets |

Tight spots: strips 1 and 2 leave 4.25 at each end of the 910; the frame screw holes leave about
3.1 of acrylic to the front edge. Optional first: one gasket and a holder plate as a test cut.

## 3. Rods (8 mm chrome rod, 400 stock, abrasive chop saw)

Hardened rod: abrasive wheel, kerf about 3. Mark on the piece you keep, cool in air, chamfer both ends.
Each rod bottoms in its end caps before a cap touches the acrylic or a loop.

| | Rod | Cuts (saw +-1) | Offcut |
|---|---|---|---|
| [ ] | 1 | 189 + 189 (holder rods) | ~19 |
| [ ] | 2 | 189 + 189 (holder rods) | ~19 |
| [ ] | 3 | 381 (door bar) | ~16 |
| | 4 | spare | 400 |

- [ ] Never cut a holder rod under 188.
- [ ] Keep one ~19 offcut: it plugs the PG13.5 gland until a heater goes in.

## 4. 1010 extrusion (aluminum)

Miter saw with a non-ferrous (TCG) blade, or a hacksaw in a guide. **Not the abrasive chop saw**:
aluminum loads the wheel. Deburr every end. Total 3465.6 plus kerfs; two parts per 1000 stick as paired below.

| | Part | Qty | Length | Cut when |
|---|---|---|---|---|
| [ ] | Shell frame, horizontal | 2 | 628.4 | after the shell is dry-fitted: measure the inside width, cut 0.2 to 0.5 under |
| [ ] | Shell frame, vertical | 2 | 226.4 | after the horizontals are in: measure between them, cut 0.2 to 0.5 under |
| [ ] | Door frame, top and bottom | 2 | 640 | against the cut door panel (flush with its edges) |
| [ ] | Door frame, sides | 2 | 238 | between the top and bottom members (door height 258 minus 2 x 10) |

Stick pairing: 628.4 + 226.4 on each of two sticks, 640 + 238 on each of two more. A member cut
long can be filed to length; one cut short cannot be fixed, so cut 1 long and sneak up.

## 5. Not yet

- [ ] Interior sheet (sheet 1: tunnel floor, walls, deck, holder plates and strips): re-nested after the
      pan is measured. Sheet 1 also needs ripping (603 is over the laser's 530 limit).
