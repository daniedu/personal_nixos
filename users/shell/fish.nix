{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      set -g fish_greeting ""
      starship init fish | source
      fastfetch --file-raw ~/.config/fastfetch/art2.txt --structure-disabled shell,cursor,locale
    '';
  };

  home.file.".config/fastfetch/art2.txt".source = ../../assets/ascii/art2.txt;
}
