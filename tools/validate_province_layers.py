#!/usr/bin/env python3
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "provinces"


def load(name):
    return json.loads((DATA / name).read_text())


def as_int_set(entries, key="id"):
    return {int(x[key]) for x in entries}


def main():
    base_payload = load("provinces_base.json")
    geom_payload = load("provinces_geometry.json")
    base = base_payload["provinces"]
    geom = geom_payload["provinces"]
    adjacency = load("province_adjacency.json")["adjacency"]
    terrain = load("province_terrain_layer.json")["provinces"]
    cities = load("province_city_layer.json")["provinces"]
    resources = load("province_resources_layer.json")["provinces"]
    projects = load("project_sites.json")["sites"]
    economy = load("province_economy_layer.json")["provinces"]
    states = load("province_states.json")["states"]
    regions = load("strategic_regions.json")["regions"]

    base_ids = as_int_set(base)
    geom_ids = as_int_set(geom)
    layer_ids = {
        int(k) for k in set(adjacency.keys())
    } | {int(k) for k in terrain.keys()} | {int(k) for k in cities.keys()} | {int(k) for k in resources.keys()} | {
        int(k) for k in economy.keys()
    }

    errors = []
    warnings = []

    # Geometry can be a staged subset while we expand toward full world coverage.
    target_geom_count = int(geom_payload.get("meta", {}).get("target_province_count", len(geom_ids)))
    if not geom_ids.issubset(base_ids):
        errors.append(
            f"Geometry has ids missing from base set: {sorted(geom_ids-base_ids)[:10]}"
        )
    if len(geom_ids) < target_geom_count:
        errors.append(
            f"Geometry count below target_province_count ({len(geom_ids)} < {target_geom_count})"
        )
    if base_ids != geom_ids:
        warnings.append(
            f"Base/geometry coverage differs (expected during staged rollout). "
            f"Missing in geometry sample: {sorted(base_ids-geom_ids)[:10]}"
        )

    if not base_ids.issubset(layer_ids):
        missing = sorted(base_ids - layer_ids)[:20]
        errors.append(f"Missing ids in layer files: {missing}")

    for site in projects:
        pid = int(site.get("province_id", -1))
        if pid not in base_ids:
            errors.append(f"Project site references missing province {pid}")
            break

    # Polygon sanity
    for entry in geom:
        pid = int(entry["id"])
        pts = entry.get("points", [])
        if len(pts) < 3:
            errors.append(f"Province {pid} has fewer than 3 points")
        for p in pts:
            if not isinstance(p, list) or len(p) < 2:
                errors.append(f"Province {pid} has malformed point")
                break

    # Adjacency symmetry
    for sid, neigh in adjacency.items():
        a = int(sid)
        for b in neigh:
            b = int(b)
            back = adjacency.get(str(b), [])
            if a not in [int(x) for x in back]:
                errors.append(f"Asymmetric adjacency {a} -> {b}")
                break

    # State / region references
    for st in states:
        for pid in st.get("province_ids", []):
            if int(pid) not in base_ids:
                errors.append(f"State {st['id']} references missing province {pid}")
                break
    for rg in regions:
        for pid in rg.get("province_ids", []):
            if int(pid) not in base_ids:
                errors.append(f"Region {rg['id']} references missing province {pid}")
                break

    if errors:
        print("VALIDATION FAILED")
        for e in errors[:50]:
            print(" -", e)
        raise SystemExit(1)

    print("VALIDATION PASSED")
    for w in warnings[:20]:
        print("WARN:", w)
    print(f"provinces={len(base_ids)} states={len(states)} regions={len(regions)}")


if __name__ == "__main__":
    main()
