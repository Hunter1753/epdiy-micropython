# Micropython build including epdiy

This repository is using the latest version of vrolands https://github.com/vroland/epdiy

Currently only works with the Lilygo T5-47 epaper display based on the ED047TC1 which is a 16 colour epaper display which supports partial refresh.
This repository currently only supports the old version using the ESP32-WROVER-E (ESP32-D0WQ6) with 8MB of PSRAM and 16MB of FLASH.

Other boards that are supported by the epdiy library should be easily addable.

It provides a micropython library to control the epaper display.

This tries to replace the outdated micropython fork by Lilygo https://github.com/Xinyuan-LilyGO/lilygo-micropython

## Prequesites

install the esp-idf 5.5.2 and esptool

## How to use

1. Clone this repo using `git clone --recurse-submodules $url` to fetch all the submodules
2. Run `prepare.sh` which sets up the micropython cross compiler and applies the neccessary patches
3. Run `build.sh` to build the firmware
4. Run `flash.sh` to use `esptool` to flash the firmware to the first connected board

## How to create a release

`git tag v1.0.0 && git push origin v1.0.0`

## Adding Custom Fonts

The firmware ships with **FiraSans** at sizes 12 and 20. Additional TTF/OTF fonts can be compiled in using `add_font.py` (single font) or `convert_fonts.py` (batch). See [docs/fonts.md](docs/fonts.md) for full details.

## API Reference

Full constants, instance methods, text measurement utilities, and a complete usage example are in [docs/api.md](docs/api.md).

# License

The code in this repository is licensed under the LGPL-3.0 License - see the LICENSE file for details.

## Third-Party Assets & Submodules:

- MicroPython: MIT License (included as a submodule).

- epdiy: LGPL-3.0 License (included as a submodule).

- Fira Sans Font: SIL Open Font License (OFL) 1.1. The font header files located in the module/fonts/ directory are derivative works of Fira Sans. See module/fonts/OFL.txt for the full license text.

