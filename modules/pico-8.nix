{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pico8;
in
{
  # =============================================================================
  # PICO-8 – the fantasy console by Lexaloffle
  # =============================================================================
  # One switch. See `pico8.enable` at the bottom of this file – that is the
  # only line you ever need to touch.
  #
  #   pico8.enable = true;    -> installed on the next rebuild
  #   pico8.enable = false;   -> removed on the next rebuild
  #
  # To turn it off, set the option in configuration.nix (NOT here – this
  # module would conflict with itself). The default is set with mkDefault, so
  # any other module can override it cleanly.
  #
  # To reclaim the disk space afterwards: nix-collect-garbage -d
  #
  # -----------------------------------------------------------------------------
  # PICO-8 is COMMERCIAL software, so this package does not download anything:
  # the purchased Linux 64-bit archive has to be in the Nix store before the
  # system can be built. If the build complains about a missing archive, run:
  #
  #   nix-prefetch-url file://$PWD/pico-8_0.2.7a6_amd64.zip
  #
  # and rebuild. The exact hash and the update steps are in
  # packages/pico-8.nix; the full story is in PICO-8.md at the repo root.
  #
  # The archive itself never enters this git repository – it lives in the Nix
  # store, and the extracted copy in assets/pico-8/ is gitignored.
  #
  # -----------------------------------------------------------------------------
  # WHAT YOU GET
  # -----------------------------------------------------------------------------
  #   pico8           the console (raw binary)
  #   pico8-wrapped   the console with wget on PATH, for Splore (the built-in
  #                   BBS browser) to download carts with
  #   pico8_dyn       fallback build that uses nixpkgs' SDL2
  #   pico8-dyn-wrapped  same, wrapped
  #
  # plus a desktop entry and icon, so PICO-8 shows up in the launcher.
  #
  # Saves, settings and downloaded carts live in ~/.lexaloffle/pico8/cdata –
  # outside the Nix store, so they survive rebuilds.
  #
  # PICO-8 is X11 only (its SDL2 build has no Wayland driver). The Mango
  # session already runs Xwayland, so it gets a window; if that ever stops,
  # set services.xserver.enable = true in modules/display.nix.
  # -----------------------------------------------------------------------------

  options.pico8 = {
    enable = lib.mkEnableOption ''
      the PICO-8 fantasy console (commercial, unfree)
    '';
  };

  config = {
    # THE TOGGLE. Flip to false and rebuild to drop PICO-8 from the system.
    # mkDefault so any other module can override it without a conflict.
    pico8.enable = lib.mkDefault true;

    environment.systemPackages = lib.mkIf cfg.enable [
      pkgs.pico-8
    ];
  };
}
