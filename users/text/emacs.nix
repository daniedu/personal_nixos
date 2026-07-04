{ pkgs, config, lib, ... }:
let
  c = config.lib.stylix.colors;
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };

  services.emacs = {
    enable = true;
  };

  home.file.".doom.d/themes/doom-stylix-theme.el" = {
    force = true;
    text = ''
    ;;; doom-stylix-theme.el --- Auto-generated from Stylix -*- lexical-binding: t; no-byte-compile: t; -*-

    (require 'doom-themes)

    (def-doom-theme doom-stylix
      "A Doom theme derived from Stylix's base16 scheme."
      :family 'doom-one
      :background-mode 'dark

      ((bg         '("#${c.base00}" "black"          "black"))
       (bg-alt     '("#${c.base01}" "#1e1e1e"        "brightblack"))
       (fg         '("#${c.base05}" "#bfbfbf"        "brightwhite"))
       (fg-alt     '("#${c.base06}" "#2d2d2d"        "white"))

       (base0      '("#${c.base00}" "black"          "black"))
       (base1      '("#${c.base01}" "#1e1e1e"        "brightblack"))
       (base2      '("#${c.base02}" "#2e2e2e"        "brightblack"))
       (base3      '("#${c.base03}" "#262626"        "brightblack"))
       (base4      '("#${c.base04}" "#3f3f3f"        "brightblack"))
       (base5      '("#${c.base05}" "#525252"        "brightblack"))
       (base6      '("#${c.base06}" "#6b6b6b"        "brightblack"))
       (base7      '("#${c.base07}" "#979797"        "brightblack"))
       (base8      '("#${c.base07}" "#dfdfdf"        "white"))

       (grey       base4)
       (red        '("#${c.base08}" "#ff6655"        "red"))
       (orange     '("#${c.base09}" "#dd8844"        "brightred"))
       (green      '("#${c.base0B}" "#99bb66"        "green"))
       (teal       '("#${c.base0C}" "#44b9b1"        "brightgreen"))
       (yellow     '("#${c.base0A}" "#ECBE7B"        "yellow"))
       (blue       '("#${c.base0D}" "#51afef"        "brightblue"))
       (dark-blue  '("#${c.base06}" "#2257A0"        "blue"))
       (magenta    '("#${c.base0E}" "#c678dd"        "brightmagenta"))
       (violet     '("#${c.base0E}" "#a9a1e1"        "magenta"))
       (cyan       '("#${c.base0C}" "#46D9FF"        "brightcyan"))
       (dark-cyan  '("#${c.base03}" "#5699AF"        "cyan"))

       (highlight      blue)
       (vertical-bar   (doom-darken base1 0.1))
       (selection      dark-blue)
       (builtin        cyan)
       (comments       base3)
       (doc-comments   (doom-lighten base3 0.25))
       (constants      violet)
       (functions      magenta)
       (keywords       blue)
       (methods        cyan)
       (operators      blue)
       (type           yellow)
       (strings        green)
       (variables      (doom-lighten magenta 0.4))
       (numbers        orange)
       (region         `(,(doom-lighten (car bg-alt) 0.15) ,@(doom-lighten (cdr base1) 0.35)))
       (error          red)
       (warning        yellow)
       (success        green)
       (vc-modified    orange)
       (vc-added       green)
       (vc-deleted     red)

       (modeline-fg              fg)
       (modeline-fg-alt          base4)
       (modeline-bg              (doom-darken bg-alt 0.1))
       (modeline-bg-alt          `(,(doom-darken (car bg-alt) 0.15) ,@(cdr bg)))
       (modeline-bg-inactive     `(,(car bg-alt) ,@(cdr base1)))
       (modeline-bg-inactive-alt `(,(doom-darken (car bg-alt) 0.1) ,@(cdr bg))))

      (((line-number &override) :foreground base4)
       ((line-number-current-line &override) :foreground fg)
       (mode-line
        :background modeline-bg :foreground modeline-fg)
       (mode-line-inactive
        :background modeline-bg-inactive :foreground modeline-fg-alt)
       (mode-line-emphasis :foreground highlight)))
  '';
  };
}
