{ pkgs, ... }: {
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
}
