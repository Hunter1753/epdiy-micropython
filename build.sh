#!/bin/sh

cd micropython/ports/esp32
idf.py -D MICROPY_BOARD=LILYGO_T5_47 -D USER_C_MODULES=module/micropython.cmake -B build build