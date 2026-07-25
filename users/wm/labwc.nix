{ config, pkgs, lib, ... }:
let
  c = config.lib.stylix.colors;
  ravenTheme = pkgs.fetchzip {
    url = "https://github.com/addy-dclxvi/openbox-theme-collections/archive/master.tar.gz";
    hash = "sha256-aC6AA09S/NE74fFNQXK8R/AVA3w4JWKjhcgEkCtGGdk=";
  };
in {
  xdg.configFile = {
    "labwc/rc.xml".text = ''
      <?xml version="1.0"?>
      <labwc_config>
        <core>
          <gap>5</gap>
          <adaptiveSync>complete</adaptiveSync>
        </core>

        <theme>
          <name><openbox-uri>${ravenTheme}/Raven-Crimson/openbox-3</openbox-uri></name>
          <cornerRadius>8</cornerRadius>
          <keepBorder>no</keepBorder>
          <dropShadows>yes</dropShadows>
          <titlebar>
            <layout>close,iconify,max:icon</layout>
            <showTitle>yes</showTitle>
          </titlebar>
          <font place="ActiveWindow">
            <name>JetBrainsMono Nerd Font</name>
            <size>10</size>
          </font>
          <font place="MenuItem">
            <name>JetBrainsMono Nerd Font</name>
            <size>10</size>
          </font>
          <font place="OSD">
            <name>JetBrainsMono Nerd Font</name>
            <size>10</size>
          </font>
          <font place="WindowTitle">
            <name>JetBrainsMono Nerd Font</name>
            <size>10</size>
          </font>
        </theme>

        <keyboard>
          <default />
          <key key="W-Space">
            <action name="Execute">
              <command>vicinae open</command>
            </action>
          </key>
          <key key="W-Return">
            <action name="Execute">
              <command>kitty</command>
            </action>
          </key>
          <key key="W-q">
            <action name="Close" />
          </key>
          <key key="W-Tab">
            <action name="NextWindow">
              <allWorkspaces>false</allWorkspaces>
              <raise>true</raise>
            </action>
          </key>
          <key key="W-f">
            <action name="ToggleMaximize" />
          </key>
          <key key="W-e">
            <action name="Execute">
              <command>nautilus</command>
            </action>
          </key>

          <key key="W-1">
            <action name="GoToDesktop">
              <to>1</to>
            </action>
          </key>
          <key key="W-2">
            <action name="GoToDesktop">
              <to>2</to>
            </action>
          </key>
          <key key="W-3">
            <action name="GoToDesktop">
              <to>3</to>
            </action>
          </key>
          <key key="W-4">
            <action name="GoToDesktop">
              <to>4</to>
            </action>
          </key>
          <key key="W-5">
            <action name="GoToDesktop">
              <to>5</to>
            </action>
          </key>
          <key key="W-6">
            <action name="GoToDesktop">
              <to>6</to>
            </action>
          </key>
          <key key="W-7">
            <action name="GoToDesktop">
              <to>7</to>
            </action>
          </key>
          <key key="W-8">
            <action name="GoToDesktop">
              <to>8</to>
            </action>
          </key>
          <key key="W-9">
            <action name="GoToDesktop">
              <to>9</to>
            </action>
          </key>
          <key key="W-S-1">
            <action name="SendToDesktop">
              <to>1</to>
            </action>
          </key>
          <key key="W-S-2">
            <action name="SendToDesktop">
              <to>2</to>
            </action>
          </key>
          <key key="W-S-3">
            <action name="SendToDesktop">
              <to>3</to>
            </action>
          </key>
          <key key="W-S-4">
            <action name="SendToDesktop">
              <to>4</to>
            </action>
          </key>
          <key key="W-S-5">
            <action name="SendToDesktop">
              <to>5</to>
            </action>
          </key>
          <key key="W-S-6">
            <action name="SendToDesktop">
              <to>6</to>
            </action>
          </key>
          <key key="W-S-7">
            <action name="SendToDesktop">
              <to>7</to>
            </action>
          </key>
          <key key="W-S-8">
            <action name="SendToDesktop">
              <to>8</to>
            </action>
          </key>
          <key key="W-S-9">
            <action name="SendToDesktop">
              <to>9</to>
            </action>
          </key>
          <key key="W-h">
            <action name="MoveToEdge">
              <direction>left</direction>
            </action>
          </key>
          <key key="W-l">
            <action name="MoveToEdge">
              <direction>right</direction>
            </action>
          </key>
          <key key="W-j">
            <action name="MoveToEdge">
              <direction>down</direction>
            </action>
          </key>
          <key key="W-k">
            <action name="MoveToEdge">
              <direction>up</direction>
            </action>
          </key>
          <key key="W-b">
            <action name="Execute">
              <command>toggle-waybar</command>
            </action>
          </key>
        </keyboard>

        <mouse>
          <default />
        </mouse>
      </labwc_config>
    '';

    "labwc/menu.xml".text = ''
      <?xml version="1.0"?>
      <openbox_menu>
        <menu id="root-menu" label="Root">
          <item label="Terminal">
            <action name="Execute">
              <command>kitty</command>
            </action>
          </item>
          <item label="File Manager">
            <action name="Execute">
              <command>nautilus</command>
            </action>
          </item>
          <item label="Browser">
            <action name="Execute">
              <command>helium</command>
            </action>
          </item>
          <item label="Screenshot">
            <action name="Execute">
              <command>grim -g "$(slurp)"</command>
            </action>
          </item>
          <item label="Audio Control">
            <action name="Execute">
              <command>pavucontrol</command>
            </action>
          </item>
          <item label="Krita">
            <action name="Execute">
              <command>krita</command>
            </action>
          </item>
          <item label="Vicinae">
            <action name="Execute">
              <command>vicinae open</command>
            </action>
          </item>
          <separator />
          <item label="Exit">
            <action name="Exit" />
          </item>
        </menu>
      </openbox_menu>
    '';

    "labwc/themerc-override".text = with c; ''
      border.width: 0
      window.button.width: 14
      window.button.height: 14
      window.button.spacing: 8
      window.button.hover.bg.corner-radius: 7

      window.active.border.color: #${base00}
      window.inactive.border.color: #${base00}
      window.active.title.bg.color: #${base01}
      window.inactive.title.bg.color: #${base00}
      window.active.label.text.color: #${base05}
      window.inactive.label.text.color: #${base04}

      window.active.button.unpressed.image.color: #${base05}
      window.active.button.hover.image.color: #${base0D}
      window.active.button.pressed.image.color: #${base08}
      window.inactive.button.unpressed.image.color: #${base03}
      window.inactive.button.hover.image.color: #${base0D}

      menu.border.color: #${base00}
      menu.separator.color: #${base02}
      menu.title.text.color: #${base05}
      menu.title.bg.color: #${base01}
      menu.items.text.color: #${base05}
      menu.items.disabled.text.color: #${base03}
      menu.items.active.text.color: #${base00}
      menu.items.active.bg.color: #${base0D}
      menu.items.bg.color: #${base01}

      osd.border.color: #${base00}
      osd.bg.color: #${base01}
      osd.label.text.color: #${base05}
      osd.label.bg.color: #${base01}
      osd.hilight.bg.color: #${base0D}
      osd.unhilight.bg.color: #${base00}

      window.active.shadow.size: 40
      window.inactive.shadow.size: 25
      window.active.shadow.color: #${base00}40
      window.inactive.shadow.color: #${base00}20
    '';

    "labwc/autostart".text = ''
      systemctl --user set-environment XDG_CURRENT_DESKTOP=labwc && systemctl --user restart xdg-desktop-portal &
      swaynotificationcenter &
      nm-applet --indicator &
      blueman-applet &
      awww-daemon &
      vicinae server &
      vicinae set theme stylix &
      waybar &
    '';
  };


}
