# Micropython build for the Lilygo T5-47 epaper display

This repository is using the latest version of vrolands https://github.com/vroland/epdiy

It provides a micropython library to control the epaper display based on the ED047TC1 which is a 16 colour epaper display which supports partial refresh

This repository currently only supports the old version using the ESP32-WROVER-E (ESP32-D0WQ6) with 8MB of PSRAM and 16MB of FLASH

this tries to replace the outdated micropython fork by Lilygo https://github.com/Xinyuan-LilyGO/lilygo-micropython

## Prequesites

install the current esp-idf and esptool

## How to use

1. clone this repo using `git clone --recurse-submodules $url` to fetch all the submodules
2. run `prepare.sh` which sets up the micropython cross compiler and applies the neccessary patches
3. run `build.sh` to build the firmware
4. run `flash.sh` to use `esptool` to flash the firmware to the first connected board
