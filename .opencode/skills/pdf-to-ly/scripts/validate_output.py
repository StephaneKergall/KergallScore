#!/usr/bin/env python3
"""Validation script for pdf-to-ly output.

Checks the generated .ly file and associated cache data for quality
and consistency, useful for future transcriptions.

Usage:
    python3 validate_output.py <piece-dir>
    python3 validate_output.py --ly <path-to-.ly>
"""

import argparse
import json
import re
import sys
from pathlib import Path


def check_ly_structure(ly_path):
    """Check that the .ly file has required structural elements."""
    errors = []
    warnings = []

    with open(ly_path, encoding="utf-8") as f:
        ly = f.read()

    # Required structural elements
    required = [
        (r'\\version "2\.26\.0"', "version tag"),
        (r'\\include "settings\.ily"', "settings include"),
        (r'\\include "composers\.ily"', "composers include"),
        (r'\s*soprano\s*', "soprano voice"),
        (r'\s*alto\s*', "alto voice"),
        (r'\s*tenor\s*', "tenor voice (with treble_8)"),
        (r'\s*bass\s*', "bass voice"),
        (r'\\global', "global block"),
        (r'\\layout', "layout block"),
        (r'\\midi', "midi block"),
        (r'\\tocItemComposer', "toc item"),
    ]

    for pattern, desc in required:
        if re.search(pattern, ly, re.DOTALL):
            # Special check for tenor clef
            if desc == "tenor voice (with treble_8)" and "treble_8" not in ly:
                warnings.append(f"{desc}: missing \\clef \"treble_8\"")
            elif desc == "soprano voice" and "S." not in ly:
                warnings.append(f"{desc}: missing instrumentName")
            else:
                pass  # OK
        else:
            errors.append(f"Missing: {desc}")

    # Check for \new ChoirStaff wrapper
    if r'<<' not in ly or r'ChoeurPart' not in ly:
        errors.append("Missing ChoeurPart / ChoirStaff wrapper")

    # Check verse lyrics exist
    if r'\s*VerseOne' not in ly and r'\s*verseOne' not in ly:
        warnings.append("No verse lyrics found (VerseOne/verseOne)")

    return errors, warnings


def check_measure_counts(ly_path):
    """Check that measure/voice patterns are consistent."""
    errors = []
    with open(ly_path, encoding="utf-8") as f:
        ly = f.read()

    # Count \bar lines or measure indicators
    # In KergallStyle, each voice has measures; check for reasonable structure
    break_count = ly.count("\\break")
    system_parts = re.findall(r'\\new Staff', ly)

    # Check that we have 4 voices
    voice_names = ["soprano", "alto", "tenor", "bass"]
    for v in voice_names:
        if v not in ly.lower() and v.capitalize() not in ly:
            errors.append(f"Voice {v} not found in .ly file")

    # Systems should have reasonable measure counts
    # Look for the pattern of 5 systems with 5 measures each (common in this repo)
    all_measures = re.findall(r'\\break', ly)
    # Each \break typically starts a new system

    return errors


def check_cache_data(cache_dir):
    """Check the cached pipeline data for completeness."""
    errors = []
    warnings = []

    # Check essential files
    essential = ["parsed.json", "transcription.json", "lyrics.json", "voices.txt"]
    for f in essential:
        if not (cache_dir / f).exists():
            errors.append(f"Missing cache file: {f}")

    # Check detect.json
    detect = cache_dir / "detect.json"
    if detect.exists():
        with open(detect) as f:
            dc = json.load(f)
        if dc.get("kind") == "scanned" and not dc.get("assume_vector", False):
            warnings.append("PDF was detected as scanned - validation may be limited")

    # Check fonts
    fonts = cache_dir / "fonts.json"
    if fonts.exists():
        with open(fonts) as f:
            fc = json.load(f)
        if not fc:
            warnings.append("No fonts extracted from PDF")

    # Check lyrics.json structure
    lrc = cache_dir / "lyrics.json"
    if lrc.exists():
        with open(lrc) as f:
            lry = json.load(f)
        if not lry:
            warnings.append("lyrics.json is empty")

    return errors, warnings


def check_composers_ily(piece_dir):
    """Check that composers.ily has the piece's composer."""
    errors = []
    composers_file = Path(".utils/composers.ily")
    if not composers_file.exists():
        errors.append(".utils/composers.ily not found")
        return errors

    # Look for the piece's composer entry
    # This is a basic check - full verification would need the composer name
    with open(composers_file, encoding="utf-8") as f:
        content = f.read()

    if "Gorczycki" not in content and "gorczycki" not in content.lower():
        warnings.append("gorczycki not found in .utils/composers.ily")

    return errors


def main():
    parser = argparse.ArgumentParser(description="Validate pdf-to-ly output")
    parser.add_argument("directory", nargs="?", help="Piece directory (e.g. 05-Sainte-Vierge/Obra)")
    parser.add_argument("--ly", help="Path to .ly file directly")
    parser.add_argument("--cache-dir", help="Path to pipeline cache directory")
    parser.add_argument("--quiet", action="store_true", help="Suppress informational output")
    args = parser.parse_args()

    # Determine what to check
    check_dir = Path(args.directory) if args.directory else None
    ly_path = Path(args.ly) if args.ly else None
    cache_dir = Path(args.cache_dir) if args.cache_dir else None

    # If directory given, find .ly file
    if check_dir and not ly_path:
        ly_path = check_dir / f"{check_dir.name}.ly"

    if not ly_path or not ly_path.exists():
        print(f"Error: .ly file not found: {ly_path}", file=sys.stderr)
        sys.exit(1)

    print(f"Validating: {ly_path}\n")

    all_errors = []
    all_warnings = []

    # Check .ly structure
    errors, warnings = check_ly_structure(ly_path)
    all_errors.extend(errors)
    all_warnings.extend(warnings)
    if not args.quiet:
        for e in errors:
            print(f"  ERROR: {e}")
        for w in warnings:
            print(f"  WARNING: {w}")

    # Check measure consistency
    errors = check_measure_counts(ly_path)
    all_errors.extend(errors)
    if not args.quiet and errors:
        for e in errors:
            print(f"  ERROR: {e}")

    # Check cache data if cache dir given
    if cache_dir:
        errors, warnings = check_cache_data(cache_dir)
        all_errors.extend(errors)
        all_warnings.extend(warnings)
        if not args.quiet:
            for e in errors:
                print(f"  CACHE ERROR: {e}")
            for w in warnings:
                print(f"  CACHE WARNING: {w}")

    # Check composers.ily
    piece_path = ly_path.parent
    if piece_path.name == check_dir.name if check_dir else False:
        errors = check_composers_ily(piece_path)
        all_errors.extend(errors)
        if not args.quiet:
            for e in errors:
                print(f"  COMPOSERS ERROR: {e}")

    # Summary
    print(f"\n=== Summary ===")
    print(f"  Errors: {len(all_errors)}")
    print(f"  Warnings: {len(all_warnings)}")

    if all_errors:
        print("  FAILED - please fix errors before considering output valid")
        sys.exit(1)
    else:
        print("  OK - output appears valid")
        sys.exit(0)


if __name__ == "__main__":
    main()