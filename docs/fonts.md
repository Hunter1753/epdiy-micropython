# Adding Custom Fonts

The firmware ships with **FiraSans** at sizes 12 and 20. You can compile additional TTF/OTF fonts into the firmware using the provided scripts. Font binary files are gitignored so there are no licensing issues when committing.

## Prerequisites

```
pip install freetype-py
```

## `add_font.py` — convert a single font at one size

```
python add_font.py <font_file> <FontName> <size> [--compress]
```

| Argument | Description |
|----------|-------------|
| `font_file` | Path to a `.ttf` or `.otf` file |
| `FontName` | C-identifier name for the font family, e.g. `Roboto` |
| `size` | Point size as an integer, e.g. `18` |
| `--compress` | Compress glyph bitmaps with zlib (recommended — saves flash) |

The generated header is placed in `module/userfonts/<FontName>/` and the font registry is updated automatically.

```bash
python add_font.py ~/Downloads/Roboto-Regular.ttf Roboto 18 --compress
```

## `convert_fonts.py` — batch-convert an entire folder

Drop any number of `.ttf` / `.otf` files into the `fonts/` directory, then run:

```
python convert_fonts.py <size1> [<size2> ...] [--compress]
```

The font family name is derived from the filename stem using CamelCase conversion (`roboto-regular.ttf` → `RobotoRegular`). All fonts in `fonts/` are converted at every requested size in one pass.

```bash
python convert_fonts.py 16 24 32 --compress
```

## Removing user fonts

To delete all generated user font headers and reset the registry to empty:

```bash
./clean_userfonts.sh
```

This removes every font family directory under `module/userfonts/` and regenerates an empty `userfonts.h`. The built-in `FiraSans` headers in `module/fonts/` are not affected.

## Regenerating the registry

If you manually add or remove header files inside `module/userfonts/`, regenerate `userfonts.h` without re-converting any fonts:

```bash
python add_font.py --regen-registry
```

## Using custom fonts

After running either script, rebuild the firmware (`build.sh`). The new fonts are then available by passing the font name to any text method:

```python
# Built-in font (font_name omitted → defaults to "FiraSans")
epd.write_text(10, 20, "hello", 12)

# Custom font
epd.write_text(10, 20, "hello", 18, "Roboto")

# Query all available fonts at runtime
print(epd.list_fonts())
# → [('FiraSans', 12), ('FiraSans', 20), ('Roboto', 18)]
```

---

← [Back to README](../README.md)
