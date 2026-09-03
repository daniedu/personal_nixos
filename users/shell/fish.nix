{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      set -g fish_greeting ""
      alias nvf="nix run github:daniedu/personal_nvf"
      # allow Ctrl-s / Ctrl-q to reach neovim (disable terminal flow control)
      if status is-interactive
        stty -ixon 2>/dev/null; or true
      end
      starship init fish | source
      fastfetch --file-raw ~/.config/fastfetch/art2.txt --structure OS:Kernel:Uptime:Shell:Terminal:CPU:GPU:MEMORY:DISK:DISPLAY:COLORS
    '';
  };

  home.file.".config/fastfetch/art2.txt".source = ../../assets/ascii/art2.txt;
}
