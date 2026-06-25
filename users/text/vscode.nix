{ pkgs, ... }: {
  programs.vscode = {
    enable  = true;
    package = pkgs.vscode-fhs;
    extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
      ms-vscode.cmake-tools
      vadimcn.vscode-lldb
      danielgavin.ols
    ];
    userSettings = {
      "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
      "cmake.configureOnOpen" = true;
    };
  };
}
