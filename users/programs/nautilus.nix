{
  config,
  lib,
  pkgs,
  ...
}:
# Builds a GTK icon theme that inherits Adwaita and recolours the blues in its
# places/mimetypes/devices icons (folders, locations, file types). Every colour
# comes from the active `stylix.base16Scheme`: the accent is the scheme's own
# base0B, and the lighter and darker tones are mixed from it.
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

  # Opt-in named hues, used only when `nautilus.folderAccent.colour` names one.
  # The default does not come from here: it takes the accent straight from the
  # scheme's base0B, so the icons follow a theme change on their own.
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
  base16Slots = lib.filter (name: builtins.match "base0[0-9A-F]" name != null) (lib.attrNames c);
  # A base16 slot keeps the folder following the scheme across theme swaps;
  # the named hues are there for when one specific tone is wanted instead.
  slot = name: "#${lib.removePrefix "#" c."${name}-hex"}";
  accent =
    let name = config.nautilus.folderAccent.colour;
    in
    if accents ? ${name}
    then hslToHex accents.${name}
    else slot name;

  themeName = "StylixAccent";
  root = "share/icons/${themeName}";
  adwaita = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
  # Adwaita paints folders from one blue family and most location and file
  # icons from another, so a folder-only recolour leaves blue monitors and
  # blue page accents sitting next to accent-coloured folders. Map both
  # families onto the accent, keeping their light/dark structure: values are
  # mixed towards the scheme's background and highlight rather than flattened.
  tones =
    body: {
      # folder.svg: shaded back flap, body, two gradient stops, lit front flap
      "#438de6" = mix body c.base00-hex 0.32;
      "#62a0ea" = body;
      "#afd4ff" = mix body tint 0.62;
      "#c0d5ea" = mix body tint 0.82;
      "#a4caee" = mix body tint 0.28;
      # blue accent family used by the remaining icons
      "#3584e4" = body;
      "#4b96d8" = mix body c.base00-hex 0.12;
      "#1c71d8" = mix body c.base00-hex 0.28;
      "#1a5fb4" = mix body c.base00-hex 0.4;
      "#204a87" = mix body c.base00-hex 0.58;
      "#14498a" = mix body c.base00-hex 0.55;
      "#98c1f1" = mix body tint 0.55;
      "#99c1f1" = mix body tint 0.55;
      "#b3d3f9" = mix body tint 0.75;
    };
  tint = mix c.base0D-hex "#ffffff" 0.55;
  directories = [
    "scalable/places"
    "scalable/mimetypes"
    "scalable/devices"
  ];

  recolour =
    body:
    let
      palette = tones body;
      pattern = lib.concatStringsSep "|" (lib.attrNames palette);
      rules = lib.concatMapStringsSep " \\\n          " (hex: "-e 's|${hex}|${palette.${hex}}|g'") (lib.attrNames palette);
    in
    ''
      for dir in ${lib.concatStringsSep " " directories}; do
        mkdir -p "$out/${root}/$dir"
        for src in ${adwaita}/$dir/*.svg; do
          if grep -Eq '${pattern}' "$src"; then
            sed ${rules} "$src" > "$out/${root}/$dir/$(basename "$src")"
          fi
        done
      done

      if grep -rqE '${pattern}' "$out/${root}/scalable/places" "$out/${root}/scalable/devices"; then
        echo "recolour left unconverted colours" >&2
        exit 1
      fi

      # Adwaita draws inode-directory as a monitor; GTK apps ask for it when
      # they mean "folder", so hand them the recoloured folder instead.
      cp "$out/${root}/scalable/places/folder.svg" "$out/${root}/scalable/mimetypes/inode-directory.svg"
    '';

  indexTheme = pkgs.writeText "index.theme" ''
    [Icon Theme]
    Name=${themeName}
    Comment=Adwaita folders recoloured with the stylix scheme
    Inherits=Adwaita
    Example=folder
    DesktopDefault=48
    DesktopSizes=16,22,32,48,64,72,96,128
    Directories=${lib.concatStringsSep "," directories}

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

    [scalable/devices]
    Size=128
    MinSize=8
    MaxSize=512
    Context=Devices
    Type=Scalable
  '';

  theme = pkgs.runCommand "${themeName}-icon-theme"
    {
      nativeBuildInputs = [ (lib.getBin pkgs.gtk4) ];
    } ''
    ${recolour accent}

    cp ${indexTheme} "$out/${root}/index.theme"

    gtk4-update-icon-cache -f -t "$out/${root}"
  '';

in
{
  options.nautilus.folderAccent = {
    colour = lib.mkOption {
      type = lib.types.enum (accentNames ++ base16Slots);
      default = "base0B";
      example = "purple";
      description = ''
        Accent colour for the recoloured folder icons. Defaults to base0B, the
        accent slot of `stylix.base16Scheme`, so the icons follow a theme
        change on their own. Set a base16 slot (base00-base0F) or one of the
        named hues to override that.
      '';
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
