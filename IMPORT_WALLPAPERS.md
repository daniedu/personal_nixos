# Import Wallhaven wallpapers

Move downloaded Wallhaven wallpapers from Vicinae support dir into this repo's `assets/wallpapers/`.

Source (Vicinae extension `store.vicinae.wallhaven`):

```text
${XDG_DATA_HOME:-$HOME/.local/share}/vicinae/support/store.vicinae.wallhaven/downloads/
```

## Move (run from repo root)

```bash
mkdir -p assets/wallpapers
mv -n "${XDG_DATA_HOME:-$HOME/.local/share}/vicinae/support/store.vicinae.wallhaven/downloads/"* assets/wallpapers/
```

Verify:

```bash
ls assets/wallpapers | wc -l
ls -t assets/wallpapers | head
```

## Notes

- Uses `mv -n` (no-clobber) so existing files in `assets/wallpapers/` are not overwritten.
- Moving removes the originals, so Vicinae's Downloaded Wallpapers view will drop those entries (it only lists files still on disk, max 50 history entries).
- If the source dir is empty, `mv` will report `No such file or directory` — nothing to do.
