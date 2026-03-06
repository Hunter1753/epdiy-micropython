#!/bin/sh

BOARD=${1:-LILYGO_T5_47}
LAST_BOARD_FILE=".last_board"

# If the board has changed since last build, fullclean and re-prepare
if [ -f "$LAST_BOARD_FILE" ]; then
    LAST_BOARD=$(cat "$LAST_BOARD_FILE")
    if [ "$LAST_BOARD" != "$BOARD" ]; then
        echo "Board changed from $LAST_BOARD to $BOARD. Running fullclean and prepare..."
        sh fullclean.sh
        sh prepare.sh
    fi
else
    echo "No previous build found. Running prepare..."
    sh prepare.sh
fi

echo "$BOARD" > "$LAST_BOARD_FILE"

cd micropython/ports/esp32
idf.py -D MICROPY_BOARD=$BOARD -D USER_C_MODULES=$(pwd)/../../../module/micropython.cmake -B ../../../build/$BOARD build
