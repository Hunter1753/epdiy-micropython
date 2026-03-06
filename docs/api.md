# API Reference

Colors are expressed as integers 0–15 (4-bit grayscale: 0 = black, 15 = white).

## Constants

| Name | Description |
|------|-------------|
| `epdiy.WIDTH` | Display width in pixels (board-dependent, e.g. 960 for ED047TC1) |
| `epdiy.HEIGHT` | Display height in pixels (board-dependent, e.g. 540 for ED047TC1) |
| `epdiy.MODE_DU` | Direct update mode (fast, 2-level) |
| `epdiy.MODE_GC16` | 16-level grayscale mode (flashing) |
| `epdiy.MODE_GL16` | 16-level grayscale mode (non-flashing, default) |
| `epdiy.MODE_A2` | Fast animation mode (2-level) |
| `epdiy.ALIGN_LEFT` | Left-align text lines (default) |
| `epdiy.ALIGN_RIGHT` | Right-align text lines |
| `epdiy.ALIGN_CENTER` | Centre-align text lines |
| `epdiy.DRAW_BACKGROUND` | Fill the text bounding box with the background color |
| `epdiy.MONO_HMSB` | Framebuf format: 1 bpp (matches `framebuf.MONO_HMSB` = 4) |
| `epdiy.GS2_HMSB` | Framebuf format: 2 bpp grayscale (matches `framebuf.GS2_HMSB` = 5) |
| `epdiy.GS4_HMSB` | Framebuf format: 4 bpp grayscale (matches `framebuf.GS4_HMSB` = 2) |
| `epdiy.ROT_LANDSCAPE` | Landscape orientation (default, 960×540) |
| `epdiy.ROT_PORTRAIT` | Portrait orientation (540×960) |
| `epdiy.ROT_INVERTED_LANDSCAPE` | Landscape, rotated 180° |
| `epdiy.ROT_INVERTED_PORTRAIT` | Portrait, rotated 180° |

## `epdiy.EPD()`

Constructor. Initialises the display driver. Only one instance may exist at a time; raises `OSError(EBUSY)` if another is live.

## Instance methods

### Lifecycle

| Method | Description |
|--------|-------------|
| `epd.deinit()` | Release the display hardware. The object must not be used afterwards. |
| `epd.poweron()` | Enable the display panel power supply. Must be called before `update()` / `update_area()`. |
| `epd.poweroff()` | Disable the display panel power supply. |
| `epd.temperature()` | Return the ambient temperature (float, °C). Returns 0.0 when no sensor is fitted. |

### Drawing (framebuffer)

All drawing methods write to an in-memory framebuffer. Call `update()` or `update_area()` to push changes to the panel.

| Method | Description |
|--------|-------------|
| `epd.clear()` | Full hardware clear (power is managed internally and turned off afterwards). |
| `epd.clear_area(x, y, w, h [, cycles [, cycle_time]])` | Partial hardware flash-clear of a rectangle. Manages power internally. `cycles` defaults to 3; `cycle_time` is the pulse length in µs (default 50). |
| `epd.fill(color)` | Fill the entire framebuffer with `color`. |
| `epd.pixel(x, y, color)` | Set a single pixel. |
| `epd.get_pixel(x, y)` | Read back the current color (0–15) of a pixel from the framebuffer. |
| `epd.hline(x, y, w, color)` | Draw a horizontal line of width `w`. |
| `epd.vline(x, y, h, color)` | Draw a vertical line of height `h`. |
| `epd.line(x0, y0, x1, y1, color)` | Draw a line between two points. |
| `epd.rect(x, y, w, h, color)` | Draw a rectangle outline. |
| `epd.fill_rect(x, y, w, h, color)` | Draw a filled rectangle. |
| `epd.circle(x, y, r, color)` | Draw a circle outline with radius `r` centred at `(x, y)`. |
| `epd.fill_circle(x, y, r, color)` | Draw a filled circle. |
| `epd.triangle(x0, y0, x1, y1, x2, y2, color)` | Draw a triangle outline between three vertices. |
| `epd.fill_triangle(x0, y0, x1, y1, x2, y2, color)` | Draw a filled triangle. |
| `epd.round_rect(x, y, w, h, r, color)` | Draw a rounded-rectangle outline with corner radius `r`. |
| `epd.fill_round_rect(x, y, w, h, r, color)` | Draw a filled rounded rectangle with corner radius `r`. |
| `epd.arc(x, y, r, start, end, color)` | Draw an arc outline of radius `r` centred at `(x, y)` from angle `start` to `end`. |
| `epd.fill_arc(x, y, r, start, end, color)` | Draw a filled pie wedge (arc + two radii). |
| `epd.write_text(x, y, text, size [, font_name])` | Draw `text` at `(x, y)`. `font_name` defaults to `"FiraSans"`; pass a custom font name to use a user-added font. Raises `ValueError` if the name/size combination is not available. Uses the colors and alignment set by the methods below. |
| `epd.set_text_color(fg [, bg])` | Set foreground color (and optionally background color) for `write_text`. Colors are 0–15. |
| `epd.set_text_align(flags)` | Set text alignment / background drawing flags. Pass one or more `epdiy.ALIGN_*` / `epdiy.DRAW_BACKGROUND` constants combined with `\|`. |
| `epd.set_fallback_glyph(codepoint)` | Set the Unicode codepoint used as a substitute when a requested glyph is absent from the font. Pass `0` to disable (default). |
| `epd.reset_text_props()` | Reset all font properties to defaults (black foreground, no background, left-aligned, no fallback glyph). |
| `epd.draw_framebuf(buf, width, height, format, x, y)` | Blit a MicroPython framebuffer (or any buffer-protocol object) onto the display framebuffer at `(x, y)`. See below. |
| `epd.set_rotation(rot)` | Set the display rotation. Pass one of the `epdiy.ROT_*` constants. Affects all subsequent drawing and font calls. |
| `epd.get_rotation()` | Return the current rotation as an integer (one of the `epdiy.ROT_*` values). |
| `epd.rotated_width()` | Display width after the current rotation is applied. Equal to `WIDTH` in landscape, `HEIGHT` in portrait. |
| `epd.rotated_height()` | Display height after the current rotation is applied. Equal to `HEIGHT` in landscape, `WIDTH` in portrait. |

### Text measurement

These methods measure text without drawing anything, useful for layout calculations.

| Method | Returns | Description |
|--------|---------|-------------|
| `epd.get_string_rect(x, y, text, size [, margin=0 [, font_name]])` | `(x, y, w, h)` | Bounding rectangle of `text` when drawn at `(x, y)`. Handles `\n` newlines. `margin` is added to width and height. `font_name` defaults to `"FiraSans"`. |
| `epd.get_text_bounds(x, y, text, size [, font_name])` | `(x1, y1, w, h)` | Tight bounding box of `text`. `x1`/`y1` may differ from the cursor position due to glyph offsets. Does not handle newlines. `font_name` defaults to `"FiraSans"`. |
| `epd.font_metrics(size [, font_name])` | `(ascender, descender, advance_y)` | Vertical metrics of the font: pixels above/below the baseline and line spacing. `font_name` defaults to `"FiraSans"`. |
| `epd.glyph_info(codepoint, size [, font_name])` | `(width, height, advance_x, left, top)` or `None` | Metrics of the glyph for the given Unicode codepoint. Returns `None` if the codepoint is not present in the font. `font_name` defaults to `"FiraSans"`. |
| `epd.list_fonts()` | `[(name, size), ...]` | List all available fonts as `(font_name, size)` tuples — built-in and user-added. |

```python
# Centre a label horizontally
x, y, w, h = epd.get_string_rect(0, 100, "Hello world", 20)
epd.write_text((epdiy.WIDTH - w) // 2, 100, "Hello world", 20)

# Draw a background box with 4 px padding before writing text
x, y, w, h = epd.get_string_rect(20, 50, "Label", 12, margin=4)
epd.fill_rect(x, y, w, h, 15)          # white box
epd.write_text(20, 50, "Label", 12)

# Use font metrics for precise multiline layout
asc, desc, adv = epd.font_metrics(20)
line_height = adv                        # pixels between baselines
```

### `epd.arc(x, y, r, start, end, color)` / `epd.fill_arc(x, y, r, start, end, color)`

Draw an arc outline or a filled pie wedge centred at `(x, y)` with radius `r`.

| Parameter | Description |
|-----------|-------------|
| `x`, `y` | Centre of the arc |
| `r` | Radius in pixels |
| `start` | Start angle in degrees (float or int) |
| `end` | End angle in degrees (float or int) |
| `color` | Gray value 0–15 |

Angles follow screen convention: **0° = right (east), 90° = down, increasing clockwise**. Pass `start=0, end=360` (or any range ≥ 360°) to draw a full circle / disc.

```python
import epdiy

epd = epdiy.EPD()
epd.clear()

# Quarter-circle arc (top-right quadrant)
epd.arc(200, 200, 80, 0, 90, 0)

# Filled pie slice (bottom half)
epd.fill_arc(500, 270, 120, 0, 180, 0)

epd.poweron()
epd.update()
epd.poweroff()
```

### `epd.draw_framebuf(buf, width, height, format, x, y)`

Blits a MicroPython-compatible framebuffer onto the epdiy framebuffer at position `(x, y)`.

| Parameter | Description |
|-----------|-------------|
| `buf` | Buffer-protocol object: `framebuf.FrameBuffer`, `bytearray`, or `bytes` |
| `width` | Pixel width of the source buffer |
| `height` | Pixel height of the source buffer |
| `format` | Pixel format — one of `epdiy.MONO_HMSB`, `epdiy.GS2_HMSB`, or `epdiy.GS4_HMSB` (identical to the `framebuf` module constants) |
| `x`, `y` | Top-left destination position on the display |

Pixel format mapping to epdiy grayscale (0 = black, 15 = white):

| Format | Bits/pixel | Mapping |
|--------|-----------|---------|
| `MONO_HMSB` | 1 | 0 → black (0), 1 → white (15) |
| `GS2_HMSB` | 2 | 0 → 0, 1 → 5, 2 → 10, 3 → 15 |
| `GS4_HMSB` | 4 | direct (0–15) |

Pixels that fall outside the display bounds are silently clipped. The method only writes to the in-memory framebuffer; call `update()` or `update_area()` to push changes to the panel.

```python
import framebuf, epdiy

epd = epdiy.EPD()
epd.clear()
buf = bytearray(200 * 100 // 2)                      # GS4_HMSB: 4 bpp
fb  = framebuf.FrameBuffer(buf, 200, 100, framebuf.GS4_HMSB)
fb.fill(15)                                           # white background
fb.text("Hello", 0, 0, 0)                            # black text
epd.draw_framebuf(fb, 200, 100, epdiy.GS4_HMSB, 10, 10)
epd.poweron()
epd.update()
epd.poweroff()
```

### Refresh

| Method | Description |
|--------|-------------|
| `epd.update([mode])` | Push the full framebuffer to the panel. `mode` defaults to `MODE_GL16`. Must be called between `poweron()` and `poweroff()`. |
| `epd.update_area(x, y, w, h [, mode])` | Partial refresh of the given rectangle. `mode` defaults to `MODE_GL16`. Must be called between `poweron()` and `poweroff()`. |
| `epd.push_pixels(x, y, w, h, time, color)` | Low-level voltage push directly to the panel, bypassing waveforms. `time` is the pulse duration in µs. `color`: `0` = darken, `1` = lighten, `2` = neutral. Must be called between `poweron()` and `poweroff()`. |
| `epd.refresh([x, y, w, h])` | Force-redraw the framebuffer (or a sub-area) to the panel, managing power internally. Unlike `update()`, this unconditionally redraws every pixel in the area regardless of what changed. Always uses `MODE_GC16`. |

## Example

> **Note:** The pixel coordinates below assume the default 960×540 display (ED047TC1). Adjust them for other boards using `epdiy.WIDTH` and `epdiy.HEIGHT`.

```python
import time
import epdiy

epd = epdiy.EPD()
epd.clear()                          # full hardware clear

# --- background ---
epd.fill(15)                         # white background

# --- temperature readout ---
temp = epd.temperature()
epd.set_text_color(0)                # black text, no background
epd.write_text(10, 20, "Temp: {:.1f} C".format(temp), 12)

# --- title (centred, white on black) ---
epd.set_text_color(15, 0)
epd.set_text_align(epdiy.ALIGN_CENTER | epdiy.DRAW_BACKGROUND)
epd.write_text(480, 40, "epdiy demo", 20)
epd.reset_text_props()

# --- filled shapes ---
epd.fill_rect(20, 80, 180, 100, 0)          # black filled rectangle
epd.rect(210, 80, 180, 100, 0)              # rectangle outline
epd.fill_circle(490, 130, 50, 3)            # dark-grey filled circle
epd.circle(600, 130, 50, 0)                 # circle outline
epd.fill_triangle(660, 180, 720, 80, 780, 180, 5)   # filled triangle
epd.triangle(800, 180, 860, 80, 920, 180, 0)        # triangle outline

# --- rounded rectangles ---
epd.fill_round_rect(20, 210, 180, 80, 20, 2)        # dark filled
epd.round_rect(210, 210, 180, 80, 20, 0)            # outline

# --- arcs / pie wedges ---
epd.fill_arc(520, 330, 80, 0, 270, 4)       # 3/4 filled pie
epd.arc(700, 330, 80, 0, 270, 0)            # 3/4 arc outline

# --- lines and pixels ---
epd.hline(20, 320, 380, 0)                  # horizontal line
epd.vline(385, 320, 80, 0)                  # vertical line
epd.line(20, 340, 420, 380, 0)              # diagonal line
epd.pixel(480, 450, 0)                      # single pixel

# --- right-aligned label ---
epd.set_text_align(epdiy.ALIGN_RIGHT)
epd.write_text(900, 500, "bottom-right", 12)
epd.reset_text_props()

# --- push full frame ---
epd.poweron()
epd.update(epdiy.MODE_GL16)
epd.poweroff()
time.sleep(5)

# --- partial update: redraw just the title bar ---
epd.fill_rect(200, 0, 560, 60, 15)
epd.set_text_color(0)
epd.set_text_align(epdiy.ALIGN_CENTER)
epd.write_text(480, 35, "partial refresh", 20)
epd.reset_text_props()
epd.poweron()
epd.update_area(200, 0, 560, 60, epdiy.MODE_GC16)
epd.poweroff()
time.sleep(2)

# --- demonstrate rotation ---
epd.set_rotation(epdiy.ROT_PORTRAIT)
print("rotation:", epd.get_rotation())      # 1 (portrait)
epd.write_text(270, 30, "portrait mode", 20)
epd.poweron()
epd.update()
epd.poweroff()
epd.set_rotation(epdiy.ROT_LANDSCAPE) #reset rotation


epd.deinit()
del epd
```

---

← [Back to README](../README.md)
