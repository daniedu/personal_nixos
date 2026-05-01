{ pkgs, inputs, ... }: {
  # Home Manager needs this to know who it's managing
  home.username = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion = "25.11";

  # Import MangoWM Home Manager module
  imports = [ inputs.mango.hmModules.mango ];

  # User-specific packages
  home.packages = with pkgs; [
    ghostty
    # Add other work apps here
  ];

  programs.mango.enable = true;

  # Basic Ghostty config
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
    };
  };
}
