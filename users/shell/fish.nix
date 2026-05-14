{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      set -g fish_greeting ""
      starship init fish | source
      fastfetch --file-raw ~/.config/fastfetch/padoru.txt --logo-width 20 --structure-disabled shell,cursor,locale
    '';
  };

  home.file.".config/fastfetch/padoru.txt".source = ../../assets/ascii/padoru.txt;
}
