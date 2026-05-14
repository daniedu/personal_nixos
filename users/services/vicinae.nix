{ pkgs, inputs, lib, config, ... }: {
  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      font = {
        normal = {
          size = 12;
          family = "JetBrainsMono Nerd Font";
        };
      };
      launcher_window = {
        opacity = lib.mkForce 1.0;
      };
    };
    extensions = [];
  };

  xdg.dataFile = let
    vx = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
    ext = name: pkg: {
      name = "vicinae/extensions/${name}";
      value.source = pkg;
    };
  in builtins.listToAttrs [
    (ext "nix"                      vx.nix)
    (ext "fuzzy-files"              vx.fuzzy-files)
    (ext "awww-switcher"            vx.awww-switcher)
    (ext "pulseaudio"               vx.pulseaudio)
    (ext "protondb-search"          vx.protondb-search)
    (ext "zoxide-recent-directories" vx.zoxide-recent-directories)
  ];
}
