{
  config,
  lib,
  pkgs,
  ...
}:
let
  c = config.lib.stylix.colors;

  hexDigits = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    a = 10;
    b = 11;
    c = 12;
    d = 13;
    e = 14;
    f = 15;
    A = 10;
    B = 11;
    C = 12;
    D = 13;
    E = 14;
    F = 15;
  };

  chars = s: builtins.map (i: builtins.substring i 1 s) (builtins.genList (i: i) (builtins.stringLength s));
  hexToRgb =
    hex:
    let
      digits = chars (if lib.hasPrefix "#" hex then lib.removePrefix "#" hex else hex);
      byte = i: (builtins.getAttr (builtins.elemAt digits i) hexDigits * 16 + builtins.getAttr (builtins.elemAt digits (i + 1)) hexDigits) / 255.0;
    in
    map byte [ 0 2 4 ];
  rgbToHex =
    rgb:
    let
      digit = n: builtins.elemAt [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ] n;
      byte =
        v:
        let
          n = lib.min 255 (lib.max 0 (builtins.floor (v * 255.0 + 0.5)));
          high = builtins.floor (n / 16.0);
        in
        "${digit high}${digit (n - 16 * high)}";
    in
    "#${lib.concatStrings (map byte rgb)}";
  mix = a: b: t: rgbToHex (lib.zipListsWith (x: y: x + (y - x) * t) (hexToRgb a) (hexToRgb b));

  hueToRgb =
    p: q: hue:
    let
      t = if hue < 0.0 then hue + 1.0 else if hue > 1.0 then hue - 1.0 else hue;
    in
    if t < 1.0 / 6.0
    then p + (q - p) * 6.0 * t
    else if t < 0.5
    then q
    else if t < 2.0 / 3.0
    then p + (q - p) * (2.0 / 3.0 - t) * 6.0
    else p;

  hslToHex =
    { h
    , s
    , l
    ,
    }:
    let
      hue = h / 360.0;
      q = if l < 0.5 then l * (1.0 + s) else l + s - l * s;
      p = 2.0 * l - q;
    in
    rgbToHex [
      (hueToRgb p q (hue + 1.0 / 3.0))
      (hueToRgb p q hue)
      (hueToRgb p q (hue - 1.0 / 3.0))
    ];

  # Hue anchors are the ones snow actually uses: warm cream for orange, the
  # sage for yellow-green, base0B for teal, base07 for blue, base0A for purple
  # and base09 for pink. Saturation is lifted past snow's pastels so the nine
  # folders stay distinguishable side by side.
  accents = {
    red = {
      h = 8;
      s = 0.62;
      l = 0.74;
    };
    orange = {
      h = 30;
      s = 0.66;
      l = 0.72;
    };
    yellow = {
      h = 52;
      s = 0.6;
      l = 0.78;
    };
    green = {
      h = 100;
      s = 0.4;
      l = 0.7;
    };
    teal = {
      h = 184;
      s = 0.44;
      l = 0.73;
    };
    blue = {
      h = 254;
      s = 0.4;
      l = 0.74;
    };
    purple = {
      h = 313;
      s = 0.38;
      l = 0.72;
    };
    pink = {
      h = 323;
      s = 0.46;
      l = 0.82;
    };
    slate = {
      h = 245;
      s = 0.18;
      l = 0.74;
    };
  };

  accentNames = lib.attrNames accents;
  themeName = "SnowAccent";
  root = "share/icons/${themeName}";
  template = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/scalable/places/folder.svg";
  tint = mix c.base0D-hex "#ffffff" 0.55;

  # Adwaita paints folder.svg from five flat tones: a shaded back flap, the
  # body, two gradient stops and a lit front flap. The accent keeps that
  # shading by mixing itself towards snow's background and highlight.
  recolour =
    body:
    let
      file = "$out/${root}/scalable/places/folder.svg";
    in
    ''
      mkdir -p "$(dirname "${file}")"
      cp ${template} "${file}"
      chmod u+w "${file}"
      sed -i \
        -e 's|#438de6|${mix body c.base00-hex 0.32}|g' \
        -e 's|#62a0ea|${body}|g' \
        -e 's|#afd4ff|${mix body tint 0.62}|g' \
        -e 's|#c0d5ea|${mix body tint 0.82}|g' \
        -e 's|#a4caee|${mix body tint 0.28}|g' \
        "${file}"
      if grep -q '#62a0ea' "${file}"; then
        echo "recolour failed" >&2
        exit 1
      fi
    '';

  indexTheme = pkgs.writeText "index.theme" ''
    [Icon Theme]
    Name=${themeName}
    Comment=Adwaita folders recoloured with the stylix scheme
    Inherits=Adwaita
    Example=folder
    DesktopDefault=48
    DesktopSizes=16,22,32,48,64,72,96,128
    Directories=scalable/places,scalable/mimetypes

    [scalable/places]
    Size=128
    MinSize=8
    MaxSize=512
    Context=Places
    Type=Scalable

    [scalable/mimetypes]
    Size=128
    MinSize=8
    MaxSize=512
    Context=MimeTypes
    Type=Scalable
  '';

  theme = pkgs.runCommand "${themeName}-icon-theme"
    {
      nativeBuildInputs = [ (lib.getBin pkgs.gtk4) ];
    } ''
    ${recolour (hslToHex accents.${config.nautilus.folderAccent.colour})}

    # GTK apps that ask for inode-directory instead of folder.
    mkdir -p "$out/${root}/scalable/mimetypes"
    cp "$out/${root}/scalable/places/folder.svg" "$out/${root}/scalable/mimetypes/inode-directory.svg"

    cp ${indexTheme} "$out/${root}/index.theme"

    gtk4-update-icon-cache -f -t "$out/${root}"
  '';

in
{
  options.nautilus.folderAccent = {
    colour = lib.mkOption {
      type = lib.types.enum accentNames;
      default = "teal";
      description = "Accent colour for folder icons, picked from the stylix scheme's hues.";
    };
  };

  config = {
    gtk.iconTheme = {
      name = themeName;
      package = theme;
    };

    home.packages = [ theme ];
  };
}
