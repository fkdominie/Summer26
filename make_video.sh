#!/usr/bin/env bash

# Make a high-quality video from LAMMPS dump image outputs:
# myimage-0.ppm, myimage-1000.ppm, ..., myimage-300000.ppm

set -e

OUT="name.mp4"
FPS=30
LIST="frames.txt"

rm -f "$LIST"

# Create a temporary frame list in correct numerical order
for f in $(ls myimage.*.ppm | sort -V); do
    echo "file '$PWD/$f'" >> "$LIST"
done

# Combine frames into high-quality video
ffmpeg -y \
    -r "$FPS" \
    -f concat \
    -safe 0 \
    -i "$LIST" \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2,format=yuv420p" \
    -c:v libx264 \
    -preset slow \
    -crf 15 \
    -movflags +faststart \
    "$OUT"

rm "$LIST"

echo "Created $OUT"