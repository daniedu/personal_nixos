{ config, lib, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
in {
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    sensibleOnTop = true;
    shortcut = "a";
    terminal = "tmux-256color";

    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'

      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind '%'

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Fix: match nvf wrapper (.nvim-wrapped) and 'nvf' command; broader 'vim' pattern
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|nvf)(diff)?$' \
          || ps -o state= -o comm= -t '#{pane_tty}' | grep -iq 'vim' \
          || ps -o state= -o comm= -t '#{pane_tty}' | grep -iq '.nvim-wrapped'"
      bind -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      bind r source-file ~/.config/tmux/tmux.conf \; display-message "reloaded"

      bind -n M-c send-keys -R \; clear-history

      set -g status-interval 5
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left "#[fg=${c.base00},bg=${c.base0D}] #S "
      set -g status-right ""

      set -g window-status-format "#[fg=${c.base07},bg=${c.base01}] #I:#W "
      set -g window-status-current-format "#[fg=${c.base00},bg=${c.base0D}] #I:#W "
      set -g window-status-separator ""

      set -g pane-border-style "fg=${c.base03},bg=default"
      set -g pane-active-border-style "fg=${c.base0D},bg=default"

      set -g message-style "fg=${c.base07},bg=${c.base01}"
      set -g message-command-style "fg=${c.base07},bg=${c.base01}"

      set -g mode-style "fg=${c.base07},bg=${c.base03}"

      set -g status-style "fg=${c.base07},bg=${c.base01}"
      set -g status-justify centre

      set -g display-time 3000
      set -g display-panes-time 3000

      set -g monitor-activity on
      set -g visual-activity off

      set -g focus-events on
      # ensure wl-copy/xclip work inside tmux (yy global) - forward Wayland/X11 vars
      set -ga update-environment " WAYLAND_DISPLAY XDG_RUNTIME_DIR XDG_SESSION_TYPE"

      # --- clipboard (OSC52) + Ctrl-key passthrough ---
      set -g allow-passthrough on
      set -g set-clipboard on
      set -g xterm-keys on
      set -s extended-keys on
      set -as terminal-features 'xterm*:extkeys'
      set -ga terminal-overrides ',*:Ms=\E]52;c;%p2%s\007'
      # ensure C-s / C-q are passed to neovim (disable XON/XOFF flow control handling)
      # (also add `stty -ixon` in shell init as fallback)
    '';
  };

  stylix.targets.tmux.enable = true;
}
