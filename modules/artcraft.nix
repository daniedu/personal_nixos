{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.artcraft;
in
{
  # =============================================================================
  # ArtCraft "Crafting Apps" – toggle for the whole suite
  # =============================================================================
  # FOUR APPS, ONE SWITCH. See `artcraft.enable` at the bottom of this file –
  # that is the only line you ever need to touch.
  #
  #   artcraft.enable = true;    -> all four installed on the next rebuild
  #   artcraft.enable = false;   -> all four removed on the next rebuild
  #
  # To reclaim the disk space afterwards: nix-collect-garbage -d
  #
  # -----------------------------------------------------------------------------
  # Four prebuilt native Rust apps from ArtCraft / storytold, each packaged from
  # its upstream AppImage in packages/:
  #
  #   photocraft    image editor, PSD import/export      packages/photocraft.nix
  #   vectorcraft   vector illustration                  packages/vectorcraft.nix
  #   filmcraft     video editor                         packages/filmcraft.nix
  #   pdfcraft      PDF workbench                        packages/pdfcraft.nix
  #
  # Each contributes two commands to the system PATH:
  #   photocraft,  photocraft-cli,  vectorcraft, vectorcraft-cli,
  #   filmcraft,   filmcraft-cli,   pdfcraft,   pdfcraft-cli
  #
  # The `-cli` halves are headless and also expose `serve` (JSON control channel)
  # and `mcp` (MCP server on stdio), so they are useful to agents and scripts and
  # cost nothing to install even if you never open a window.
  #
  # Nothing here touches flatpak. services.flatpak stays enabled in
  # modules/display.nix, it just does not own these four apps any more. That is
  # deliberate: a Flatpak of each would mean four more runtimes in
  # ~/.local/share/flatpak, a duplicate copy of every font, and an extra sandbox
  # layer between you and the compositor. The AppImages unpack into a small
  # closure and use your real system fonts.
  #
  # PERFORMANCE EXPECTATION ON THIS MACHINE (Intel Pentium G630, HD Graphics 2000)
  # These are GPU-composited apps and this box has no usable hardware GPU:
  # Intel ANV needs Broadwell/Haswell (gen8+), and Mesa 26 has dropped the legacy
  # i965 driver, so there is no i965_dri.so either. Everything therefore renders
  # on Mesa's software stack (lavapipe / llvmpipe) across 2 cores. They will open,
  # draw and save correctly – just slowly on large documents. That is the
  # hardware, not the packaging. If a given app is unusably slow at your working
  # resolution, turn the suite off rather than debugging the build.
  #
  # Updating to a newer release: each packages/*.nix has a "HOW TO UPDATE"
  # section at the top with the exact curl and nix-prefetch commands. These apps
  # release fast, so expect to run through this every few weeks.
  # -----------------------------------------------------------------------------

  options.artcraft = {
    enable = lib.mkEnableOption ''
      the ArtCraft suite: photocraft, vectorcraft, filmcraft and pdfcraft
    '';
  };

  config = {
    # THE TOGGLE. Flip to false and rebuild to drop all four from the system.
    # mkDefault so any other module can override it without a conflict.
    artcraft.enable = lib.mkDefault true;

    environment.systemPackages = lib.mkIf cfg.enable (
      with pkgs;
      [
        photocraft
        vectorcraft
        filmcraft
        pdfcraft
      ]
    );
  };
}
