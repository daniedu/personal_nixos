{ pkgs, ... }: {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "qml"
      "dart"
    ];

    extraPackages = with pkgs; [
      # QML
      qt6.qtdeclarative
      # Nix
      nil
      nixpkgs-fmt
      # TypeScript / JavaScript / Next.js
      typescript-language-server
      tailwindcss-language-server
      prettierd
      # Dart & Flutter
      dart
      flutter
    ];

    userSettings = {
      vim_mode = true;
      relative_line_numbers = true;
      auto_update = false;
      show_inline_completions = true;
      format_on_save = "on";
    };

  };

  stylix.targets.zed.enable = true;
}
