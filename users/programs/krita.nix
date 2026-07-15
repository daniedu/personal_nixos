{ config, pkgs, lib, ... }:
let
  c = config.lib.stylix.colors;

  hexVals = {
    "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
    "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
    "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
    "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
  };
  toDecimal = d: builtins.getAttr d hexVals;
  hexToDec = hex: builtins.foldl' (acc: d: acc * 16 + toDecimal d) 0 (builtins.stringToCharacters hex);
  color = hex: "${toString (hexToDec (builtins.substring 0 2 hex))},${toString (hexToDec (builtins.substring 2 2 hex))},${toString (hexToDec (builtins.substring 4 2 hex))}";

  section = name: bg: alt: fg: inactive: active: link: visited: focus: hover: ''
    [Colors:${name}]
    BackgroundNormal=${color bg}
    BackgroundAlternate=${color alt}
    ForegroundNormal=${color fg}
    ForegroundInactive=${color inactive}
    ForegroundActive=${color active}
    ForegroundLink=${color link}
    ForegroundVisited=${color visited}
    DecorationFocus=${color focus}
    DecorationHover=${color hover}
  '';
in {
  home.file.".local/share/color-schemes/stylix.colors" = {
    force = true;
    text = ''
      [General]
      Name=Stylix

      [KDE]
      ColorScheme=Stylix

      ${section "Window" c.base00 c.base01 c.base05 c.base03 c.base0D c.base0D c.base0E c.base0D c.base0C}
      ${section "View" c.base01 c.base00 c.base05 c.base04 c.base0D c.base0D c.base0E c.base0D c.base0C}
      ${section "Button" c.base02 c.base01 c.base05 c.base04 c.base0D c.base0D c.base0E c.base0D c.base0C}
      ${section "Selection" c.base0D c.base02 c.base07 c.base04 c.base0D c.base0D c.base0E c.base0D c.base0C}
      ${section "Tooltip" c.base00 c.base01 c.base05 c.base04 c.base0D c.base0D c.base0E c.base0D c.base0C}
      ${section "Header" c.base00 c.base01 c.base05 c.base04 c.base0D c.base0D c.base0E c.base0D c.base0C}
      ${section "Complementary" c.base00 c.base01 c.base05 c.base04 c.base0D c.base0D c.base0E c.base0D c.base0C}
    '';
  };
}
