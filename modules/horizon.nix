{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.horizon;
in
{
  # =============================================================================
  # Horizon – Minecraft: Java Edition 26.3 rewritten in Rust
  # =============================================================================
  #   horizon.enable = true;    -> installed on the next rebuild
  #   horizon.enable = false;   -> removed on the next rebuild
  #
  # Everything lives in the launcher:
  #
  #   horizon-launcher                      # window
  #   horizon-launcher versions             # what can be installed
  #   horizon-launcher install v0.2.97      # the release you linked
  #   horizon-launcher install latest       # or the newest
  #   horizon-launcher prepare              # resources from your Minecraft copy
  #   horizon-launcher account sign-in      # Microsoft account that owns it
  #   horizon-launcher play
  #   horizon-launcher desktop-entry        # add it to the applications menu
  #
  # Mods: the launcher ships its own Rust toolchain and native-mod builds:
  #
  #   nix develop .#horizon-mod            # C compiler, pkg-config, ALSA/udev
  #   horizon-launcher rust install
  #   horizon-launcher native-build --help
  #
  # Downloads, prepared resources, worlds and mods stay in
  # ~/.local/share/horizon-launcher, outside the Nix store and rebuilds.
  # You still need your own copy of Minecraft: Java Edition 26.3.
  # =============================================================================

  options.horizon = {
    enable = lib.mkEnableOption "the Horizon launcher (Minecraft: Java Edition in Rust)";
  };

  config = {
    horizon.enable = lib.mkDefault true;

    environment.systemPackages = lib.mkIf cfg.enable [
      pkgs.horizon-launcher
    ];
  };
}
