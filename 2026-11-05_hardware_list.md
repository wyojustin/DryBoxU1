# Dry box hardware list (2026-11-05)

Counted by hand from the panels' holes and the door mounts file. Lengths follow the rule in the
panels file: into a T-nut, screw length <= part thickness + 3.0.

## Fasteners

| Item | Qty | Where |
|---|---|---|
| M3 x 8 | 12 | panels into the shell frame (top 4, bottom 4, sides 2 each) |
| M3 x 8 | 16 | corner brackets, used on the door frame, then the shell |
| M3 x 16 | 8 | loops through the bottom panel, saddles through the top (2 each) |
| M3 x 5 | 4 | hinge rings into the door frame (2 each); 2 mm floor, so 5 is the most that fits |
| M3 x 6 | 4 | catches, leg into the door frame's outer slot (2 each) |
| M3 x 6 | 2 | handle into the door frame's outer slot |
| M3 x 10 grub | 4 | seal adjusters (2 per loop) |
| M3 nut, 5.36 AF x 2.15 | 4 | seal adjusters |
| M3 nylock | 8 | loops (inside the floor, no washers) and saddles (inside the top) |
| 1010 T-nut | 38 | 12 panels + 16 brackets + 4 rings + 4 catches + 2 handle |
| M5 nut, 4.8 thick | 2 | latch barrels |
| M5 knob, 35 thread | 2 | latches |
| 2.8 x 45 self-tapper (#4 x 1-3/4, McMaster 92525A129) | 4 | feeder cases, from behind the back wall |
| 1.5 mm hex key | 1 | grub screws |

## Other bought parts

| Item | Qty | Note |
|---|---|---|
| 608ZZ bearing | 16 | 2 per roller, 8 rollers |
| 3M 4910 VHB, 0.5 in x 5 yd | 1 roll | door frame (about 1.8 m) |
| EVA foam tape, 1/2 x 1/8 in | about 2 m | door seal, plus feeder outlet rings |
| Neutral-cure RTV | 1 | |
| PG13.5 cable gland | 1 | monochef assortment; closed on an 8 mm rod stub until a heater needs it |
| Talc | a little | exposed VHB strip |
| Silica gel, hygrometers, PTFE, feeder extension cables | as bought | |

## Printed parts

File names carry the quantity per box: `<part>_qty=<n>.stl`. Each file was checked on 2026-11-11 against a
fresh export from its `.scad` source (same volume and size).

| Part | Qty | File | Source (`part`) |
|---|---|---|---|
| Latch saddle (v10) | 2 | [stl/latch_saddle_qty=2.stl](stl/latch_saddle_qty=2.stl) | swing_latch `saddle` |
| Latch barrel | 2 | [stl/latch_barrel_qty=2.stl](stl/latch_barrel_qty=2.stl) | swing_latch `barrel` |
| Door catch | 2 | [stl/door_catch_qty=2.stl](stl/door_catch_qty=2.stl) | door_mounts `catch_print` |
| Hinge loop | 2 | [stl/hinge_loop_qty=2.stl](stl/hinge_loop_qty=2.stl) | door_mounts `keeper` |
| Hinge ring | 2 | [stl/hinge_ring_qty=2.stl](stl/hinge_ring_qty=2.stl) | door_mounts `hook` |
| Door handle | 1 | [stl/door_handle_qty=1.stl](stl/door_handle_qty=1.stl) | door_mounts `handle` |
| Bar end cap | 2 | [stl/bar_end_cap_qty=2.stl](stl/bar_end_cap_qty=2.stl) | door_mounts `bar_cap` |
| Rod end cap | 8 | [stl/rod_end_cap_qty=8.stl](stl/rod_end_cap_qty=8.stl) | spool_holder `cap` |
| Roller, 79.6 long | 8 | [stl/roller_qty=8.stl](stl/roller_qty=8.stl) | spool_holder `roller` |
| Roller washer, 1 mm | 16 | [stl/roller_washer_qty=16.stl](stl/roller_washer_qty=16.stl) | spool_holder `washer` |
| Corner bracket | 4 | [stl/corner_bracket_qty=4.stl](stl/corner_bracket_qty=4.stl) | dry_box_bracket |
| Feeder insert (v11) | 2 | [stl/feeder_insert_qty=2.stl](stl/feeder_insert_qty=2.stl) | feeder_insert |
