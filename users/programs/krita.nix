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
  strToChars = s: builtins.map (i: builtins.substring i 1 s) (builtins.genList (i: i) (builtins.stringLength s));
  hexToDec = hex: builtins.foldl' (acc: d: acc * 16 + toDecimal d) 0 (strToChars hex);
  color = hex: "${toString (hexToDec (builtins.substring 0 2 hex))},${toString (hexToDec (builtins.substring 2 2 hex))},${toString (hexToDec (builtins.substring 4 2 hex))}";

  section = name: bg: fg: accent: ''
    [Colors:${name}]
    BackgroundNormal=${color bg}
    BackgroundAlternate=${color bg}
    ForegroundNormal=${color fg}
    ForegroundInactive=${color fg}
    ForegroundActive=${color accent}
    ForegroundLink=${color accent}
    ForegroundVisited=${color accent}
    DecorationFocus=${color accent}
    DecorationHover=${color accent}
  '';
in {
  home.file.".var/app/org.kde.krita/data/krita/color-schemes/stylix.colors" = {
    force = true;
    text = ''
      [General]
      Name=Stylix

      [KDE]
      ColorScheme=Stylix

      ${section "Window" c.base00 c.base07 c.base0D}
      ${section "View" c.base00 c.base07 c.base0D}
      ${section "Button" c.base00 c.base07 c.base0D}
      ${section "Selection" c.base0D c.base07 c.base0D}
      ${section "Tooltip" c.base00 c.base07 c.base0D}
      ${section "Header" c.base00 c.base07 c.base0D}
      ${section "Complementary" c.base00 c.base07 c.base0D}
    '';
  };
}
