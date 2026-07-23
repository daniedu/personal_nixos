{ pkgs, ... }: {
  home.packages = with pkgs; [
    neovim

    (pkgs.writeShellScriptBin "ols" ''
      export ODIN_ROOT="${pkgs.odin}/share"
      exec ${pkgs.ols}/bin/ols "$@"
    '')
  ];
}
