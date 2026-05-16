{ pkgs, ... }: {
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
    stdlib = ''
      use_devenv() {
        watch_file devenv.lock
        eval "$(devenv print-dev-env --profile "$(direnv_layout_dir)")"
      }
    '';
  };

  home.packages = with pkgs; [
    devenv
  ];
}
