{ lib
, stdenvNoCC
, fetchurl
, appimageTools
, makeWrapper
, electron
, desktop-file-utils
}:

# =============================================================================
# neo-writer – NEO, a distraction-free word processor for novelists
# Upstream: https://github.com/hughhowey/neo (MIT)
#   Upstream publishes an Electron **AppImage only** for Linux (no .deb/tar.gz),
#   built with electron-builder. Releases: see downloadPage below.
#
# -----------------------------------------------------------------------------
# WHY NOT buildElectronApp / electron-builder here
# -----------------------------------------------------------------------------
# `buildElectronApp` no longer exists in nixpkgs, and a from-source
# `electron-builder --dir` build would fight the `package.json` pins
# (electron 43.7.6, electron-builder 26.15.3) for no gain – the AppImage is
# already a complete, self-contained app.
#
# Instead we do what nixpkgs' revolt-desktop / heynote do:
#   1. `appimageTools.extract` unsquashes the AppImage at build time
#      (no FUSE, no squashfs mount, no bubblewrap chroot).
#   2. We throw away the AppImage's own `neo` ELF binary and drive
#      `resources/app.asar` with nixpkgs' own `electron`.
#   => tiny closure, no AppImage runtime shim, real Nix package metadata.
#
# -----------------------------------------------------------------------------
# WHAT WE ACTUALLY TAKE FROM THE SQUASHFS (verified on v1.2.4)
# -----------------------------------------------------------------------------
#   resources/app.asar           51 MB – the whole app (main.js, index.html,
#                               fonts/, node_modules/ with 44 packages) PLUS
#                               the app's own i18n `locales/*.json`.
#                               main.js:41 does `path.join(__dirname,'locales')`
#                               -> resolves *inside* the asar, so we must NOT
#                               relocate resources/ : the asar's own location
#                               defines __dirname for every path join.
#   resources/app.asar.unpacked/ asarUnpack'd dictionary-pt, dictionary-ro, jszip.
#                               Electron maps `app.asar/X` -> `app.asar.unpacked/X`
#                               automatically, but only if the unpacked dir sits
#                               next to app.asar -> hence copy the whole resources/.
#   resources/licenses/hunspell/ MPL-1.1 + NOTICE for the bundled hunspell wasm.
#   usr/share/icons/.../neo.png  1024x1024 hicolor icon.
#   neo.desktop                   Exec=AppRun --no-sandbox %U -> rewritten below.
#
# NOT copied: the top-level `locales/` (Chromium *UI* .pak files – nixpkgs
# electron ships its own), `neo` (the bundled electron binary, replaced by
# nixpkgs `electron`), `usr/lib/libappindicator*` (main.js never constructs a
# `Tray`, so the tray libs are dead weight).
#
# -----------------------------------------------------------------------------
# ELECTRON VERSION DRIFT – the one real trade-off
# -----------------------------------------------------------------------------
# Upstream v1.2.4 bundles electron 43.7.6; nixpkgs (nixos-unstable) ships
# 43.4.1. Same major, so the Electron API surface NEO uses is unchanged, but it
# is not byte-identical to what upstream tested. If a future NEO release moves
# to Electron 44, this needs `electron >= 44` in nixpkgs first – check
# `nix eval --raw nixpkgs#electron.version` when bumping `version` below.
#
# SIDE BENEFIT: we launch `electron <app.asar>`, so Electron sets
# `process.defaultApp = true` and therefore `app.isPackaged === false`.
# main.js:1862 short-circuits on that, so `electron-updater` is never wired up:
# no surprise background self-updates, and no "APPIMAGE env is not defined"
# error on Help -> Check for Update. Updates come from `nixos-rebuild`, as they
# should in Nix.
#
# -----------------------------------------------------------------------------
# HOW TO UPDATE (manual-hash workflow – same as packages/kson-rs.nix)
# -----------------------------------------------------------------------------
# 1. Find the newest release + its AppImage:
#      curl -s https://api.github.com/repos/hughhowey/neo/releases \
#        | jq -r '.[] | select(.prerelease==false) | .tag_name, .assets[].browser_download_url'
#    Upstream tags as `v<version>`; assets are `NEO-<version>.AppImage`.
#    NOTE: upstream occasionally mislabels assets (v1.2.3 shipped files named
#    `NEO-1.2.2.AppImage`) – always read `latest-linux.yml` from the release
#    rather than assuming the filename matches the tag.
#
# 2. Update `version` below.
#
# 3. Get the new `hash` for `fetchurl`:
#      nix-prefetch-url \
#        https://github.com/hughhowey/neo/releases/download/v<NEW>/NEO-<NEW>.AppImage
#    Tip: set `hash = lib.fakeHash;` then `nix build .#neo-writer` – the error
#    prints the expected `got: sha256-...`.
#
# 4. Re-check the squashfs layout above (names are only pinned to what v1.2.4
#    used – `resources/`, `neo.desktop`, `usr/share/icons/**/neo.png`):
#      nix build --no-link --print-out-paths --impure --expr '
#        let f = builtins.getFlake (toString ./.);
#        in f.inputs.nixpkgs.legacyPackages.x86_64-linux.appimageTools.extract {
#          pname = "neo-probe"; version = "<NEW>";
#          src = f.inputs.nixpkgs.legacyPackages.x86_64-linux.fetchurl {
#            url = "..."; hash = "sha256-..."; };
#        }'
#    If a `src` path moved, update installPhase accordingly.
#
# 5. If upstream starts publishing a .deb or a plain tar.gz, prefer that over
#    the AppImage (smaller, no squashfs step, real upstream .desktop/icon).
#
# 6. Verify:
#      nix build .#neo-writer
#      ./result/bin/neo-writer          # window opens, spellcheck, save, export
#      nixos-rebuild switch --flake .#dan
#
# Rollback: revert `version`/`hash` in git.
#
# -----------------------------------------------------------------------------
# PLATFORM NOTE
# -----------------------------------------------------------------------------
# Upstream also ships an arm64 AppImage. This config hardcodes
# `system = "x86_64-linux"` in flake.nix, so we fetch the x86_64 file only.
# To go multi-arch, switch `src` to the per-`system` table style used by
# nixpkgs' revolt-desktop and prefetch the arm64 hash.
# =============================================================================

let
  pname = "neo-writer";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/hughhowey/neo/releases/download/v${version}/NEO-${version}.AppImage";
    hash = "sha256-b7N9DDVYVUkURyJyEeciaf9RixG2UvHkD78lIM4x5qE=";
  };

  # Unsquashed AppImage – the AppRun/squashfs bits are discarded by installPhase.
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
stdenvNoCC.mkDerivation rec {
  inherit pname version src;

  # The AppImage is an opaque binary; we install from `appimageContents` instead.
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  nativeBuildInputs = [
    makeWrapper
    desktop-file-utils
  ];

  installPhase = ''
    runHook preInstall

    # Resources MUST stay together: app.asar, app.asar.unpacked (for the
    # asarUnpack'd dictionaries) and the asar->unpacked path mapping.
    mkdir -p $out/share/neo-writer $out/bin
    cp -a ${appimageContents}/resources $out/share/neo-writer/resources

    # Upstream's app MIT text lives inside the asar; surface the license files
    # that ship alongside it so $out/share/licenses is not empty.
    mkdir -p $out/share/licenses/$pname
    cp -a ${appimageContents}/resources/licenses/hunspell/. \
      $out/share/licenses/$pname/

    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/neo.png \
      $out/share/icons/hicolor/1024x1024/apps/neo.png

    # Desktop entry: point Exec at our wrapper and drop the AppImage-only bits.
    # desktop-file-install rewrites in place, which the read-only store forbids,
    # so stage it outside $out and install from there.
    mkdir -p desktop
    install -Dm644 ${appimageContents}/neo.desktop desktop/$pname.desktop
    substituteInPlace desktop/$pname.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' "Exec=$pname" \
      --replace-fail 'X-AppImage-Version=1.2.4' 'X-NEO-Version=1.2.4'
    desktop-file-install --dir "$out/share/applications" --delete-original \
      desktop/$pname.desktop

    # Sanity: if electron-builder ever stops shipping the asar, fail loudly here
    # rather than with a cryptic "Unable to find Electron app" at runtime.
    test -f $out/share/neo-writer/resources/app.asar

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/$pname \
      --add-flags $out/share/neo-writer/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  meta = with lib; {
    description = "Distraction-free word processor for authors, with word goals, EPUB/Word/PDF export and offline spellcheck";
    homepage = "https://github.com/hughhowey/neo";
    downloadPage = "https://github.com/hughhowey/neo/releases";
    changelog = "https://github.com/hughhowey/neo/releases";
    # MIT for the app. Bundled hunspell dictionaries under resources/licenses are
    # MPL-1.1 (see $out/share/licenses); dictionary-pt/ro carry their own notices.
    license = licenses.mit;
    mainProgram = pname;
    maintainers = [ ];
    platforms = platforms.linux;
    # Ships prebuilt x86_64 binaries (Electron), so flag the provenance.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
