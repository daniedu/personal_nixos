{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
    # This block injects environment variables directly into direnv's engine
    config = {
      global = {
        warn_timeout = "0s"; # This natively silences the "taking a while" warning on modern direnv
      };
    };

    stdlib = ''
      export DIRENV_WARN_TIMEOUT=0 # Fallback option to guarantee silence

      use_devenv() {
        watch_file devenv.lock
        eval "$(devenv print-dev-env)"
      }
    '';
  };

  home.packages = with pkgs; [
    devenv
    nixfmt
  ];
}
