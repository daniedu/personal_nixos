{ pkgs, ... }: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: with epkgs; [
      vterm
    ];
  };

  home.packages = with pkgs; [
    doom-emacs
  ];

  services.emacs = {
    enable = true;
  };
}
