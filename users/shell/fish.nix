{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      set -g fish_greeting ""
      alias nvf="nix run github:daniedu/personal_nvf"
      starship init fish | source
      fastfetch --file-raw ~/.config/fastfetch/art2.txt --structure OS:Kernel:Uptime:Shell:Terminal:CPU:GPU:MEMORY:DISK:DISPLAY:COLORS
    '';
  };

  home.file.".config/fastfetch/art2.txt".source = ../../assets/ascii/art2.txt;
}
