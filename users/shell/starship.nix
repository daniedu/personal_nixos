{ config, lib, ... }:
let
  c = config.lib.stylix.colors;
in {
  programs.starship = {
    enable = true;
    settings = {
      format = "$username $directory $fill $git_branch$git_status $line_break $character";
      right_format = "";

      palette = lib.mkForce "stylix_palette";

      palettes = {
        stylix_palette = {
          color_accent = "#${c.base0D}";
          color_git = "#${c.base0B}";
	  color_red = "#${c.base08}";
	  # color_bg1 = "#${c.base01}"
          # color_bg3 = "#${c.base03}";
          # color_blue = "#${c.base0D}";
          # color_aqua = "#${c.base0C}";
          # color_green = "#${c.base0B}";
          # color_orange = "#${c.base09}";
          # color_purple = "#${c.base0E}";
          # color_red = "#${c.base08}";
          # color_yellow = "#${c.base0A}";
        };
      };

      username = {
        show_always = true;
        format = "[$user](fg:color_accent)";
      };

      directory = {
        format = "[$path](fg:color_accent)";
        truncation_length = 999;
      };

      git_branch = {
        symbol = "";
        format = "[$symbol$branch](fg:color_git) ";
      };

      git_status = {
        format = "[$all_status](fg:color_git)";
      };

      character = {
        format = "[$symbol](bold $style)";
        success_symbol = "$";
        error_symbol = "$";
        style_success = "fg:color_accent";
        style_failure = "fg:color_red";
      };
    };
  };
}
