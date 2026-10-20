# PICO-8

PICO-8 is commercial software by Lexaloffle. It is packaged here, but the
archive itself is **not** in this repository and never will be.

This document explains what that means in practice and what to do when
something goes wrong.

## TL;DR

| Situation | What to do |
|---|---|
| Fresh clone, new machine | Buy the archive, then run the one-liner in [Setting up](#setting-up) |
| Build fails with "the archive cannot be downloaded" | Run the one-liner in [Setting up](#setting-up) |
| `nix-collect-garbage -d` reaped the archive | Run the one-liner in [Setting up](#setting-up) again — no re-download needed if the zip is still on disk |
| Want PICO-8 gone from the system | `pico8.enable = false;` in `configuration.nix`, rebuild — see [Turning it off](#turning-it-off) |
| Want to update to a newer PICO-8 | See [Updating](#updating) |

## How it is packaged

`packages/pico-8.nix` follows the approach of the nixpkgs PR that is still
open upstream ([NixOS/nixpkgs#551567](https://github.com/NixOS/nixpkgs/pull/551567))
and the standalone flake its author published
([codeberg.org/husjon/nix-pico-8](https://codeberg.org/husjon/nix-pico-8)).

The source is a `requireFile`:

```nix
src = requireFile {
  name = "pico-8_0.2.7a6_amd64.zip";
  hash = "sha256-7fLOhUdAWFsPmIhO4J1j+auObIdy4BSKkCkntkCMnqo=";
  message = "PICO-8 is commercial software, so the archive cannot be
             downloaded automatically. ...";
};
```

`requireFile` is a fixed-output derivation whose builder is a script that
prints the message above and exits 1. **It can never produce the file.** It
only "succeeds" when the archive is already in the local Nix store, which you
put there yourself.

That is the whole trick, and it is what makes a public repository safe:

- The repository contains a *hash*, not the archive. A SHA-256 cannot be
  reversed into the file.
- Nobody else's machine, CI runner, or `nix flake check` can obtain the
  archive by building. The derivation physically cannot produce it.
- The archive is not on cache.nixos.org or any other public binary cache, and
  the package is not either. It is not in the NixOS package set at all
  (`nix eval nixpkgs#pico-8` fails) — PICO-8 is unfree, so it cannot be
  redistributed by nixpkgs.

## Setting up

Buy PICO-8 at <https://www.lexaloffle.com/pico-8.php>, download the **Linux
64-bit** archive, and load it into the Nix store:

```bash
nix-prefetch-url file://$PWD/pico-8_0.2.7a6_amd64.zip
```

That prints the hash and copies the file into `/nix/store`. Then:

```bash
nix build .#pico-8
nixos-rebuild switch --flake .#dan
```

If the printed hash differs from the one in `packages/pico-8.nix`, update
`hash` there with the value you got.

The archive is not re-downloaded by any of this — `nix-prefetch-url` reads
your local file. If you still have the zip in `~/Downloads`, running the
command again after a garbage collection takes a couple of seconds.

## Where things live

| What | Where |
|---|---|
| The archive | `/nix/store/...-pico-8_0.2.7a6_amd64.zip` (read-only) |
| The packaged console | `/nix/store/...-pico-8-0.2.7a6/` |
| Extracted copy in this repo | `assets/pico-8/` — **gitignored**, and now redundant |
| Your saves, settings, carts | `~/.lexaloffle/pico-8/` (never in the Nix store) |

`assets/pico-8/` was where the archive used to be unpacked. It is ignored by
git and is no longer needed — the build works from the store copy. You can
delete it whenever you like; it changes nothing.

## Garbage collection

The archive is the output of a fixed-output derivation, and that derivation
is an input of the built package, which is in your system closure. As long as
PICO-8 is part of the system, the archive survives garbage collection.

If you ever remove PICO-8 from the system and run `nix-collect-garbage -d`,
the archive is reaped along with it. A later rebuild then fails with the
"cannot be downloaded automatically" message. The fix is the one-liner in
[Setting up](#setting-up) — no re-download needed if the zip is still on
disk.

## Commands

| Command | What it is |
|---|---|
| `pico8` | The console. Raw binary. |
| `pico8-wrapped` | The console with `wget` on `PATH`, which is what Splore (the built-in BBS browser) needs to download carts. This is what the desktop entry launches. |
| `pico8_dyn` | Fallback build that uses nixpkgs' SDL2 instead of the built-in one. |
| `pico8-dyn-wrapped` | Same, wrapped. |

## Display

PICO-8 on Linux is **X11 only** — neither binary contains a Wayland video
driver, its SDL2 build only has the X11 one. It needs an X server.

The Mango session already runs Xwayland (`Xwayland :0 -rootless`), so PICO-8
opens its window on it with no extra configuration. If you ever switch to a
session without Xwayland, enable it:

```nix
services.xserver.enable = true;
```

Rendering goes through Mesa. On this box (Pentium G630, HD Graphics 2000,
gen6) there is no hardware GL, so it lands on llvmpipe: correct, but
CPU-bound. PICO-8's canvas is 128x128, so it is cheap either way.

## Audio

PipeWire is the sound server (see `modules/audio.nix`). PICO-8 opens ALSA and
PulseAudio, both of which land in PipeWire. No separate setup needed.

## Updating

1. Download the new archive from your Lexaloffle account:
   <https://www.lexaloffle.com/games.php?page=my>
   (specific versions: <https://www.lexaloffle.com/games.php?page=archive>)

2. Get its hash and put it in the store:

   ```bash
   nix-prefetch-url file://$PWD/pico-8_<NEW>_amd64.zip
   ```

3. Update `version` and `hash` in `packages/pico-8.nix`. The file name
   matters too — the store path of the archive is derived from it, so it has
   to match the file you downloaded.

4. Rebuild and verify:

   ```bash
   nix build .#pico-8
   ./result/bin/pico8-wrapped
   nixos-rebuild switch --flake .#dan
   ```

## Turning it off

Set the option in `configuration.nix` — **not** in `modules/pico-8.nix`, which
would conflict with itself:

```nix
# configuration.nix
{
  imports = [ ... ];

  pico8.enable = false;
}
```

The module sets the default with `lib.mkDefault`, so any other module can
override it cleanly.

```bash
nixos-rebuild switch --flake .#dan
nix-collect-garbage -d   # reclaims the package and the archive
```

## Licence

PICO-8 is not free software. It is licensed to you personally by Lexaloffle;
see `license.txt` in the archive, which this package installs to
`/nix/store/...-pico-8-0.2.7a6/share/doc/pico-8/license/license.txt`.

Nothing in this repository grants any rights to it. Do not redistribute the
archive, the package, or the store paths — the packaging exists so that
*you* can run software *you* have paid for.
