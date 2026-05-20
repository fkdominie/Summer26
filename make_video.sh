#!/usr/bin/env bash

# Make a video from LAMMPS dump image outputs:
# myimage-0.ppm, myimage-1000.ppm, ..., myimage-300000.ppm

set -e

OUT="name.mp4"
FPS=30

# Create a temporary frame list in correct numerical order
LIST="frames.txt"
rm -f "$LIST"

for f in $(ls myimage.*.ppm | sort -V); do
    echo "file '$PWD/$f'" >> "$LIST"
done

# Combine frames into video
ffmpeg -y \
    -r "$FPS" \
    -f concat \
    -safe 0 \
    -i "$LIST" \
    -vf "format=yuv420p" \
    "$OUT"

rm "$LIST"
echo "Created $OUT"
