{ pkgs, lib, config, ... }:
let c = config.lib.stylix.colors;
in {
  programs.kitty = {
    enable = true;
    settings = {
      shell = "fish";
      window_padding_width = 2;
      confirm_os_window_close = 0;
      background_opacity = lib.mkForce "0.85";
      dynamic_background_opacity = "yes";
      text_composition_strategy = "platform";
      cursor_shape = "beam";
      cursor_beam_thickness = 1.5;
      cursor_blink_interval = 0;
      tab_bar_edge = "top";
      tab_bar_style = "slant";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      enable_audio_bell = "no";
    };
  };

  stylix.targets.kitty.enable = true;
}
