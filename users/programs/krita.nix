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

  section = name: bg: fg: ''
    [Colors:${name}]
    BackgroundNormal=${color bg}
    BackgroundAlternate=${color bg}
    ForegroundNormal=${color fg}
    ForegroundInactive=${color fg}
    ForegroundActive=${color fg}
    ForegroundLink=${color fg}
    ForegroundVisited=${color fg}
    DecorationFocus=${color fg}
    DecorationHover=${color fg}
  '';
in {
  home.file.".var/app/org.kde.krita/data/krita/color-schemes/stylix.colors" = {
    force = true;
    text = ''
      [General]
      Name=Stylix

      [KDE]
      ColorScheme=Stylix

      ${section "Window" c.base00 "FFFFFF"}
      ${section "View" c.base00 "FFFFFF"}
      ${section "Button" c.base00 "FFFFFF"}
      ${section "Selection" c.base01 "FFFFFF"}
      ${section "Tooltip" c.base00 "FFFFFF"}
      ${section "Header" c.base00 "FFFFFF"}
      ${section "Complementary" c.base00 "FFFFFF"}
    '';
  };
}
