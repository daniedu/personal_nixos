{ pkgs, ... }: {
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      libva
      libva-utils
      mesa
      gst_all_1.gst-vaapi
      intel-media-driver
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
    ];
  };
}
