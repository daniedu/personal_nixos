{ pkgs, ... }: {
  programs.vscode = {
    enable  = true;
    package = pkgs.vscode-fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
      ms-vscode.cmake-tools
      vadimcn.vscode-lldb
      danielgavin.ols
    ];
    profiles.default.userSettings = {
      "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
      "clangd.arguments" = [
        "--query-driver=${pkgs.gcc}/bin/gcc,${pkgs.gcc}/bin/g++,${pkgs.clang-tools}/bin/clang,${pkgs.clang-tools}/bin/clang++"
      ];
      "cmake.configureOnOpen" = true;
    };
  };
}
