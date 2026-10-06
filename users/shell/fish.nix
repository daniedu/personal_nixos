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
      fastfetch --file-raw ~/.config/fastfetch/art.txt --structure OS:Kernel:Uptime:Shell:Terminal:CPU:GPU:MEMORY:DISK:DISPLAY:COLORS
    '';
  };

  home.file.".config/fastfetch/art.txt".source = ../../assets/ascii/kyubae.txt.txt;
}
