{ pkgs, inputs, lib, ... }: {
  programs.noctalia-shell = {
    enable  = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      bar = {
        position = "left";

        widgets = {
          left = [
            { id = "AppMenu"; }
            { id = "Workspace"; }
          ];
          center = [];
          right = [
            { id = "Tray"; }
            { id = "Volume"; }
            { id = "Clock"; }
            { id = "ControlCenter"; }
          ];
        };
      };

      launcher.enable = true;

      wallpaper.enabled = true;

      colorSchemes = {
        darkMode         = true;
        predefinedScheme = "Wallpaper";
      };

      ui.fontDefault = lib.mkForce "JetBrainsMono Nerd Font";
    };
  };
}
