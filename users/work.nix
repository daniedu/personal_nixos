{ pkgs, inputs, ... }: {
  # Home Manager needs this to know who it's managing
  home.username = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion = "25.11";

imports = [
    inputs.mango.hmModules.mango  # This tells Home Manager how to handle 'programs.mango'
  ];
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
