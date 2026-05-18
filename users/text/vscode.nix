{ pkgs, ... }: {
  programs.vscode = {
    enable  = true;

    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          dbaeumer.vscode-eslint
          esbenp.prettier-vscode
          bradlc.vscode-tailwindcss
          christian-kohler.path-intellisense
          christian-kohler.npm-intellisense
          formulahendry.auto-close-tag
          formulahendry.auto-rename-tag
          oderwat.indent-rainbow
          yoavbls.pretty-ts-errors
        ];
        userSettings = {
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.minimap.enabled" = false;
          "tailwindCSS.experimental.classRegex" = [
            [ "clsx\\(([^)]*)\\)" "(?:'|\"|`)([^'\"`]*)(?:'|\"|`)" ]
          ];
        };
      };

      laravel = {
        extensions = with pkgs.vscode-extensions; [
          bmewburn.vscode-intelephense-client
          xdebug.php-debug
          formulahendry.auto-close-tag
          formulahendry.auto-rename-tag
          editorconfig.editorconfig
          mikestead.dotenv
        ];
        userSettings = {
          "php.validate.enable" = true;
          "intelephense.files.maxSize" = 1000000;
          "editor.formatOnSave" = true;
        };
      };

      qt = {
        extensions = with pkgs.vscode-extensions; [
          ms-vscode.cpptools
          ms-vscode.cmake-tools
          twxs.cmake
          xaver.clang-format
          llvm-vs-code-extensions.vscode-clangd
        ];
        userSettings = {
          "clangd.path" = "clangd";
          "cmake.configureOnOpen" = true;
          "editor.formatOnSave" = true;
        };
      };
    };
  };
}
