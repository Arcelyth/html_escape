#!/usr/bin/env python3

import json
from pathlib import Path

INPUT_JSON = "./src/entities.json"
OUTPUT_MBT = "./src/entities.mbt"

def moonbit_escape(s: str) -> str:
    """
    Escape string for MoonBit source.
    """
    return (
        s.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )

def canonicalize_entity(name: str) -> str:
    """
    Convert:

        &AElig   -> AElig
        &AElig;  -> AElig

    into canonical entity name.
    """
    if name.startswith("&"):
        name = name[1:]

    if name.endswith(";"):
        name = name[:-1]

    return name

def main():
    with open(INPUT_JSON, "r", encoding="utf-8") as f:
        entities = json.load(f)

    canonical_entities = {}

    for entity_name, value in entities.items():
        canonical_name = canonicalize_entity(entity_name)
        characters = value["characters"]

        if canonical_name not in canonical_entities:
            canonical_entities[canonical_name] = characters

    lines = []

    lines.append("///|")
    lines.append("/// Auto-generated from gen_entities.py")
    lines.append("/// Source: https://html.spec.whatwg.org/entities.json")
    lines.append("/// DO NOT EDIT MANUALLY.")
    lines.append(
        f"pub let html_entities : Array[(String, String)] = ["
    )

    for entity_name in sorted(canonical_entities):
        characters = canonical_entities[entity_name]

        entity_name = moonbit_escape(entity_name)
        characters = moonbit_escape(characters)

        lines.append(
            f'  ("{entity_name}", "{characters}"),'
        )

    lines.append("]")
    lines.append("")

    Path(OUTPUT_MBT).write_text(
        "\n".join(lines),
        encoding="utf-8",
    )

    print(
        f"Generated {OUTPUT_MBT} "
    )


if __name__ == "__main__":
    main()
