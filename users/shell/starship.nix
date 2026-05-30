{ config, lib, ... }:
let
  c = config.lib.stylix.colors;
in {
  programs.starship = {
    enable = true;
    settings = {
      format = "[\\($username@$directory\\)](fg:color_accent) $character ";
      right_format= "$git_branch$git_status";

      palette = lib.mkForce "stylix_palette";

      palettes = {
        stylix_palette = {
          color_accent = "#${c.base0D}";
          color_git = "${c.base0B}";
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
        format = "[$symbol$branch](fg:color_git)";
      };

      git_status = {
        format = "[$all_status](fg:color_git)";
      };

      character = {
        success_symbol = "[](bold fg:color_accent)";
        error_symbol = "[](bold fg:color_base08)";
      };
    };
  };
}
