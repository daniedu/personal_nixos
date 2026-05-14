{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      set -g fish_greeting ""
      starship init fish | source
      fastfetch --file-raw ~/.config/fastfetch/cat.txt --logo-width 20 --structure-disabled shell,cursor,locale
    '';
  };

  home.file.".config/fastfetch/cat.txt".source = ../../assets/ascii/cat.txt;
}
