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

## How to create a release

`git tag v1.0.0 && git push origin v1.0.0`

## API Reference

Colors are expressed as integers 0–15 (4-bit grayscale: 0 = black, 15 = white).

### Constants

| Name | Description |
|------|-------------|
| `epdiy.WIDTH` | Display width in pixels (960) |
| `epdiy.HEIGHT` | Display height in pixels (540) |
| `epdiy.MODE_DU` | Direct update mode (fast, 2-level) |
| `epdiy.MODE_GC16` | 16-level grayscale mode (flashing) |
| `epdiy.MODE_GL16` | 16-level grayscale mode (non-flashing, default) |
| `epdiy.MODE_A2` | Fast animation mode (2-level) |

### `epdiy.EPD()`

Constructor. Initialises the display driver. Only one instance may exist at a time; raises `OSError(EBUSY)` if another is live.

### Instance methods

#### Lifecycle

| Method | Description |
|--------|-------------|
| `epd.deinit()` | Release the display hardware. The object must not be used afterwards. |
| `epd.poweron()` | Enable the display panel power supply. Must be called before `update()` / `update_area()`. |
| `epd.poweroff()` | Disable the display panel power supply. |
| `epd.temperature()` | Return the ambient temperature (float, °C). Falls back to 25 °C when no sensor is fitted. |

#### Drawing (framebuffer)

All drawing methods write to an in-memory framebuffer. Call `update()` or `update_area()` to push changes to the panel.

| Method | Description |
|--------|-------------|
| `epd.clear()` | Full hardware clear (power is managed internally and turned off afterwards). |
| `epd.fill(color)` | Fill the entire framebuffer with `color`. |
| `epd.pixel(x, y, color)` | Set a single pixel. |
| `epd.hline(x, y, w, color)` | Draw a horizontal line of width `w`. |
| `epd.vline(x, y, h, color)` | Draw a vertical line of height `h`. |
| `epd.line(x0, y0, x1, y1, color)` | Draw a line between two points. |
| `epd.rect(x, y, w, h, color)` | Draw a rectangle outline. |
| `epd.fill_rect(x, y, w, h, color)` | Draw a filled rectangle. |
| `epd.circle(x, y, r, color)` | Draw a circle outline with radius `r` centred at `(x, y)`. |
| `epd.fill_circle(x, y, r, color)` | Draw a filled circle. |

#### Refresh

| Method | Description |
|--------|-------------|
| `epd.update([mode])` | Push the full framebuffer to the panel. `mode` defaults to `MODE_GL16`. Must be called between `poweron()` and `poweroff()`. |
| `epd.update_area(x, y, w, h [, mode])` | Partial refresh of the given rectangle. `mode` defaults to `MODE_GL16`. Must be called between `poweron()` and `poweroff()`. |

### Example

```python
import epdiy

epd = epdiy.EPD()
epd.clear()
epd.fill(15)                          # white background
epd.fill_rect(10, 10, 200, 100, 0)   # black rectangle
epd.poweron()
epd.update(epdiy.MODE_GL16)
epd.poweroff()
epd.deinit()
del epd
```

