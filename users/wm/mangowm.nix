{ pkgs, ... }: {
  wayland.windowManager.mango = {
    enable = true;
    systemd.enable = true;

    autostart_sh = ''
      swaynotificationcenter &
      nm-applet --indicator &
      blueman-applet &
      awww-daemon &
      vicinae server &
      vicinae set theme stylix &
      export WLR_NO_HARDWARE_CURSORS=1
    '';

    settings = {
      # Input
      xkb_rules_layout = "us";
      sloppyfocus = 1;

      # Touchpad
      trackpad_natural_scrolling = 1;
      disable_while_typing = 1;
      click_method = 2;
      tap_to_click = 1;
      drag_lock = 1;
      trackpad_scroll_factor = 0.5;

      # Gaps & borders
      gappih = 5;
      gappiv = 5;
      gappoh = 10;
      gappov = 10;
      borderpx = 1;
      border_radius = 0;
      focuscolor = "0x00000000";

      # Blur
      blur = 1;
      blur_optimized = 1;
      blur_params_radius = 5;
      blur_params_num_passes = 2;

      # Misc
      focus_on_activate = 1;
      animations = 0;

      # Layout cycling
      circle_layout = "tile,grid,scroller,monocle";

      # Keybindings
      bind = [
        "SUPER,space,spawn,vicinae open"
        "SUPER,Return,spawn,kitty"
        "SUPER,w,killclient"
        "SUPER,m,quit"
        "SUPER,f,togglefullscreen"
        "SUPER,e,spawn,nautilus"

        "SUPER,h,focusdir,left"
        "SUPER,l,focusdir,right"
        "SUPER,j,focusdir,up"
        "SUPER,k,focusdir,down"

        "SUPER+SHIFT,h,exchange_client,left"
        "SUPER+SHIFT,l,exchange_client,right"
        "SUPER+SHIFT,j,exchange_client,up"
        "SUPER+SHIFT,k,exchange_client,down"
        
        "SUPER,1,view,1"
        "SUPER,2,view,2"
        "SUPER,3,view,3"
        "SUPER,4,view,4"
        "SUPER,5,view,5"
        "SUPER,6,view,6"
        "SUPER,7,view,7"
        "SUPER,8,view,8"
        "SUPER,9,view,9"

        "SUPER+SHIFT,1,tag,1"
        "SUPER+SHIFT,2,tag,2"
        "SUPER+SHIFT,3,tag,3"
        "SUPER+SHIFT,4,tag,4"
        "SUPER+SHIFT,5,tag,5"
        "SUPER+SHIFT,6,tag,6"
        "SUPER+SHIFT,7,tag,7"
        "SUPER+SHIFT,8,tag,8"
        "SUPER+SHIFT,9,tag,9"

        "SUPER,p,spawn,wlr-which-key"
        "SUPER,Tab,switch_layout"
        "SUPER+SHIFT,space,togglefloating"
        "SUPER+SHIFT,V,togglefloating"
        "SUPER+SHIFT,S,setlayout,scroller"
        "SUPER+SHIFT,T,setlayout,tile"
      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
        "SUPER+ALT,btn_left,moveresize,curresize"
      ];
    };
  };
}
