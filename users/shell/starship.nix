{ config, lib, ... }:
let
  c = config.lib.stylix.colors;
in {
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory $fill $git_branch $git_status $line_break$character";
      right_format = "";

      fill = {
        symbol = " ";
      };

      palette = lib.mkForce "stylix_palette";

      palettes = {
        stylix_palette = {
          color_accent = "#${c.base0D}";
          color_git = "#${c.base0B}";
          color_red = "#${c.base08}";
        };
      };

      username = {
        show_always = true;
        format = "[$user](fg:color_accent)";
      };

      directory = {
        format = "[$path](fg:color_accent)";
        truncation_length = 999;
        truncate_to_repo = false;
      };

      git_branch = {
        symbol = "";
        format = "[$symbol $branch](fg:color_git) ";
      };

      git_status = {
        format = "[$all_status](fg:color_git)";
      };

      character = {
        success_symbol = "[➜](bold fg:color_accent)";
        error_symbol = "[➜](bold fg:color_red)";
      };
    };
  };
}
