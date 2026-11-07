# DryBoxU1

Desiccant-only filament dry box for a Snapmaker U1, in the middle bay of the printer cart (opening
648 wide). Laser-cut 6 mm cast acrylic shell (5.8 measured) with finger joints, a 1010 extrusion
front frame, and a front door that hinges on an 8 mm bar at the top and swings down. Inside: 2
laser-cut spool holders (4 spinning spools on printed rollers with 608 bearings) feeding the U1's
2 feeders through the back wall, a desiccant pan in a tunnel under a perforated deck, and 6 spare
spools stacked flat.

OpenSCAD 2021.01. Units mm. Files start with the date they were created (`yyyy-mm-dd_name`).
Each `.scad` file's header says what it is and lists its `part` / `view` options.

## Current files

| File | What |
|---|---|
| `2026-10-30_dry_box_panels.scad` | Shell: dimensions, finger joints, all holes; panel outlines for the laser |
| `2026-10-30_dry_box_sheets.scad` | Shell panels nested on the ripped strips (`strip = 1..4`) |
| `2026-11-05_interior.scad` | Tunnel, deck, holder plates nested on the spare sheet; feeder gaskets |
| `2026-11-04_spool_holder.scad` | Spool holders, rollers, washers, rod end caps |
| `2026-11-04_door_mounts.scad` | Top hinge (loop, seal adjusters, ring hook, bar), bottom catch, handle |
| `2026-11-03_swing_latch.scad` | Swing-bolt latch: saddle and barrel |
| `2026-11-02_feeder_insert.scad` | Feeder insert v11 (released) |
| `2026-10-31_dry_box_bracket.scad` | 1010 corner bracket |
| `2026-11-03_dry_box_assembly.scad` | Full assembly for viewing; prints the cut list |
| `2026-11-05_hardware_list.md` | Fasteners, bought parts, printed parts |

The other `.scad` files are concepts, gauges, fit tests and views from along the way, kept for the
record (several are superseded; their headers say so).

## Folders

- `cut/`: laser files (SVG) as staged for cutting, and the cut list. Remove the film before cutting.
- `stl/`: printed parts, including tested fits. Some are imported by the assembly.
- `renders/` and the dated PNGs: views and renders, a visual log.

## Before cutting

Every design choice gets closed out first. Open items are tracked in the shared notes
(`2026-10-31_dry_box_purchases.md`): measure the desiccant pan and size the tunnel to it; fix the
top/bottom back-corner cubes (give them to the back panel); measure the PG13.5 thread; test-cut a
gasket and one holder plate.
