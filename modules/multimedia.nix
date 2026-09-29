{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ffmpeg-full
    mpv
    vlc
    eog
    evince
  ];
}
