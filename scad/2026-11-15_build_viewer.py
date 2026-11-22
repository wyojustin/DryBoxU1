"""2026-11-15 Build the rotatable 3D viewer page for the dry box.

OpenSCAD cannot export colors, so the assembly is exported once per component.
This script makes a working copy of 2026-11-03_dry_box_assembly.scad (the
original is not touched) in which color() is replaced by a filter that keeps
only one color per pass, and the uncolored or shared-color pieces are tagged
with grp("name"). Each pass becomes one mesh in the page.

Usage: python3 2026-11-15_build_viewer.py WORK_DIR OUT_HTML
"""
import base64
import json
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
PROJECT = os.path.dirname(HERE)
ASSEMBLY = os.path.join(HERE, "2026-11-03_dry_box_assembly.scad")
TEMPLATE = os.path.join(HERE, "2026-11-15_viewer_template.html")
X, Y, Z = 640.0, 430.0, 258.0            # shell size, checked against the scad

PRELUDE = '''// GENERATED working copy for the 3D viewer export. Do not edit.
pass = "none";
$force = false;
module color(c, alpha) {
    if (pass == "discover") echo(str("CKEY|", c));
    if ($force || pass == str(c)) children();
}
module grp(n) { if (pass == n) { $force = true; children(); } }
'''

# (old text, new text): each must occur exactly once in the assembly file
EDITS = [
    ("    holder();", '    grp("holder") holder();'),
    ("flip() bar();", 'grp("bar") flip() bar();'),
    ("color([0.95, 0.55, 0.1]) keeper(); adjusters();",
     'grp("hinge") keeper(); grp("bar") adjusters();'),
    ("    bottom_latch(lx, door_angle > 0 ? 90 : 0);",
     '    grp("latch") bottom_latch(lx, door_angle > 0 ? 90 : 0);'),
    ("if (show_door) flip() door_swing() {",
     'if (show_door) grp("door_frame") flip() door_swing() {'),
    ("if (show_door) acrylic([0.85, 0.92, 1.0]) flip() door_swing()",
     'if (show_door) grp("door_panel") flip() door_swing()'),
    ('if (show_top) acrylic([0.80, 0.88, 1.0]) render() panel3d("top");',
     'grp("top") render() panel3d("top");'),
    ('acrylic([0.80, 0.88, 1.0]) for (p = ["bottom", "back", "left", "right"])',
     'grp("shell") for (p = ["bottom", "back", "left", "right"])'),
    ("acrylic([0.80, 0.88, 1.0]) translate([tun_x[0], ext + 0.5, t])",
     'grp("tunnel") translate([tun_x[0], ext + 0.5, t])'),
    ("acrylic([0.80, 0.88, 1.0]) for (x = tun_x)", 'grp("tunnel") for (x = tun_x)'),
    ("acrylic([0.85, 0.92, 1.0]) translate([tun_x[0], 1, deck_z])",
     'grp("deck") translate([tun_x[0], 1, deck_z])'),
]

DOOR = dict(id="door", label="Door open", on=True)
OPEN, SHUT = ["door", True], ["door", False]

# pass, label, color, opacity, extras. A pass is a grp name or a color key
# exactly as OpenSCAD prints it with str().
PARTS = [
    ("shell", "Shell", "#cfe3ff", 0.25, {}),
    ("top", "Lid", "#cfe3ff", 0.25, {}),
    ("[0.75, 0.76, 0.78]", "Front frame and seal", "#bfc2c7", 1, {"metal": True}),
    ("[0.2, 0.2, 0.22]", "Front frame and seal", "#333338", 1, {}),
    ("[0.25, 0.25, 0.25]", "Front frame and seal", "#404040", 1, {}),
    ("door_frame", "Door", "#b3b5ba", 1, {"door": True}),
    ("door_panel", "Door", "#d9ebff", 0.25, {"door": True}),
    ("bar", "Hinge and latches", "#8c8c94", 1, {"metal": True}),
    ("hinge", "Hinge and latches", "#f28c1a", 1, {}),
    ("latch", "Hinge and latches", "#f28c1a", 1, {"door": True}),
    ("holder", "Spool holders", "#9fc3e6", 0.7, {}),
    ("tomato", "Feeding spools", "#ff6347", 1, {}),
    ("burlywood", "Spare spools", "#deb887", 1, {}),
    ("[0.78, 0.79, 0.81]", "Desiccant pan", "#c7c9cf", 1, {"metal": True}),
    ("tunnel", "Tunnel and deck", "#cfe3ff", 0.3, {}),
    ("deck", "Tunnel and deck", "#d9ebff", 0.35, {}),
    ("[0.95, 0.55, 0.1]", "Feeders and tubes", "#f28c1a", 1, {}),
    ("[0.15, 0.15, 0.17]", "Feeders and tubes", "#26262b", 1, {}),
    ("white", "Feeders and tubes", "#f5f5f5", 1, {}),
    ("black", "Feeders and tubes", "#111111", 1, {}),
    ("[0.3, 0.3, 0.3]", "Feeders and tubes", "#4d4d4d", 1, {}),
    ("[0.6, 0.6, 0.65]", "Feeders and tubes", "#999aa6", 1, {}),
    ("red", "Feeders and tubes", "#e02020", 1, {}),
    ("[0.92, 0.96, 1]", "Feeders and tubes", "#ebf5ff", 1, {}),
    ("silver", "Feeders and tubes", "#c0c0c0", 1, {"metal": True}),
    ("[0.35, 0.36, 0.4]", "Cart bay", "#595c66", 1, {"metal": True}),
]


def fail(msg):
    print(f"ERROR: {msg}", file=sys.stderr)
    sys.exit(1)


def make_working_copy(path):
    t = open(ASSEMBLY).read()
    for old, new in EDITS:
        n = t.count(old)
        if n != 1:
            fail(f"assembly changed: expected exactly one {old!r}, found {n}")
        t = t.replace(old, new)
    t, n_use = re.subn(r"use <(2026-)", f"use <{HERE}/\\1", t)
    t, n_imp = re.subn(r'import\("\.\./stl/', f'import("{PROJECT}/stl/', t)
    if n_use == 0 or n_imp == 0:
        fail(f"path rewrite found {n_use} use and {n_imp} import statements")
    m = re.search(r"t = [\d.]+; X = ([\d.]+); Z = ([\d.]+); Y = ([\d.]+);", t)
    if not m or [float(v) for v in m.groups()] != [X, Z, Y]:
        fail("shell size in the assembly no longer matches X, Y, Z in this script")
    open(path, "w").write(PRELUDE + t)


def openscad(scad, out, defs):
    cmd = ["openscad", "-o", out]
    for k, v in defs.items():
        cmd += ["-D", f"{k}={v}"]
    return subprocess.run(cmd + [scad], capture_output=True, text=True)


def export(job):
    scad, work, name, pass_, door_angle = job
    out = os.path.join(work, name + ".stl")
    r = openscad(scad, out, {"pass": json.dumps(pass_), "door_angle": door_angle})
    if r.returncode != 0 or not os.path.exists(out):
        return name, None, r.stderr[-400:]
    return name, out, ""


def read_stl(path):
    rows = [line.split()[1:4] for line in open(path) if line.lstrip().startswith("vertex")]
    v = np.array(rows, dtype=np.float64)
    if len(v) == 0 or len(v) % 3:
        fail(f"{path}: {len(v)} vertices is not a triangle list")
    return v


def to_view(v):
    """Scad (x width, y depth with the front at 0, z up) to viewer (y up, front toward +z)."""
    return np.column_stack([v[:, 0] - X / 2, v[:, 2] - Z / 2, -(v[:, 1] - Y / 2)])


def b64(a, dtype):
    return base64.b64encode(np.ascontiguousarray(a, dtype=dtype).tobytes()).decode()


def main():
    if len(sys.argv) != 3:
        fail(__doc__)
    work, out_html = sys.argv[1:]
    os.makedirs(work, exist_ok=True)
    scad = os.path.join(work, "assembly_passes.scad")
    make_working_copy(scad)

    # every top-level color must be assigned to a part, or it would be dropped
    r = openscad(scad, os.path.join(work, "discover.echo"), {"pass": '"discover"'})
    found = set(re.findall(r"CKEY\|(.*?)\"", open(os.path.join(work, "discover.echo")).read()))
    known = {p[0] for p in PARTS}
    if not found:
        fail(f"color discovery found nothing: {r.stderr[-300:]}")
    if found - known:
        fail(f"assembly colors with no part assigned: {sorted(found - known)}")

    # nothing may be left outside color() and grp(): the empty pass must export nothing
    r = openscad(scad, os.path.join(work, "none.stl"), {"pass": '"none"'})
    if os.path.exists(os.path.join(work, "none.stl")):
        fail("some geometry is not inside color() or grp(); it would appear in every part")

    jobs, meta = [], []
    for i, (pass_, label, color, opacity, extra) in enumerate(PARTS):
        states = [(160, OPEN), (0, SHUT)] if extra.get("door") else [(160, None)]
        for angle, variant in states:
            name = f"p{i:02d}_{angle}"
            jobs.append((scad, work, name, pass_, angle))
            meta.append(dict(name=name, pass_=pass_, label=label, color=color,
                             opacity=opacity, metal=bool(extra.get("metal")), variant=variant))
    with ThreadPoolExecutor(6) as pool:
        results = {name: (path, err) for name, path, err in pool.map(export, jobs)}

    parts, n_tri, skipped = [], 0, []
    for m in meta:
        path, err = results[m["name"]]
        if path is None:
            skipped.append(f"{m['pass_']} ({m['label']}): {err.strip().splitlines()[-1] if err.strip() else 'no output'}")
            continue
        v = to_view(read_stl(path))
        uniq, idx = np.unique(np.round(v, 3), axis=0, return_inverse=True)
        n_tri += len(v) // 3
        parts.append(dict(label=m["label"], color=m["color"], opacity=m["opacity"],
                          metal=m["metal"], variant=m["variant"],
                          pos=b64(uniq, "<f4"), idx=b64(idx.reshape(-1), "<u4")))
    if skipped:
        fail("these passes exported nothing:\n  " + "\n  ".join(skipped))

    data = dict(parts=parts, variants=[DOOR], view=dict(center=[0, 0, 0], dist=1700))
    html = open(TEMPLATE).read()
    for marker, value in (("__TITLE__", "DryBoxU1"),
                          ("__SUBTITLE__", "640 &times; 430 &times; 258 mm &middot; 4 feeding spools, 6 spares"),
                          ("__DATA__", json.dumps(data))):
        if marker not in html:
            fail(f"template has no {marker} marker")
        html = html.replace(marker, value)
    os.makedirs(os.path.dirname(os.path.abspath(out_html)), exist_ok=True)
    open(out_html, "w").write(html)
    print(f"{len(parts)} meshes, {n_tri} triangles, {len(html) / 1e6:.2f} MB -> {out_html}")


if __name__ == "__main__":
    main()
