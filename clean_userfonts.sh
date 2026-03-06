#!/bin/sh

USERFONTS_DIR="module/userfonts"

echo "Removing user font families from $USERFONTS_DIR ..."
for entry in "$USERFONTS_DIR"/*/; do
    [ -d "$entry" ] && rm -rf "$entry" && echo "  Removed: $entry"
done

echo "Regenerating empty registry..."
python3 add_font.py --regen-registry

echo "User fonts cleared."
