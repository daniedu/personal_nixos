{ pkgs, ... }: {
  hardware.graphics = {
    enable      = true;
    enable32Bit = true;

    # mesa provides radeonsi (VA-API/VDPAU) + radv (Vulkan) for 8600G 760M (gfx1103)
    # intel-media-driver kept for Intel while still on this machine (harmless on AMD, ~10MB)
    extraPackages = with pkgs; [
      libva
      libva-utils
      mesa
      gst_all_1.gst-vaapi
      intel-media-driver
      vulkan-loader
      vulkan-tools
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      libva
      vulkan-loader
    ];
  };
}
