{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_add_path ~/.local/bin
      set -g fish_greeting ""
      # The nvim config lives in ~/Projects/nixosconfig/personal_nvf.
      #
      # "path:" points at the checkout, so an edit is live on the next run -
      # no push, and no stale cache. "github:" would serve a cached revision
      # and silently run the old config until the cache is refreshed, which
      # cost an afternoon of "the LSP says lua-language-server" confusion.
      #
      # Swap to this on a machine without the checkout:
      #   alias nvf="nix run --refresh github:daniedu/personal_nvf"
      alias nvf="nix run path:/home/work/Projects/nixosconfig/personal_nvf"
      # allow Ctrl-s / Ctrl-q to reach neovim (disable terminal flow control)
      if status is-interactive
        stty -ixon 2>/dev/null; or true
      end
      fastfetch --file-raw ~/.config/fastfetch/art.txt --structure OS:Kernel:Uptime:Shell:Terminal:CPU:GPU:MEMORY:DISK:DISPLAY:COLORS
    '';
  };

  home.file.".config/fastfetch/art.txt".source = ../../assets/ascii/copland.txt;
}
