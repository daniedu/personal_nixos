{ pkgs, ... }: {
  xdg.configFile = {
    "labwc/rc.xml".text = ''
      <?xml version="1.0"?>
      <labwc_config>
        <core>
          <gap>5</gap>
          <adaptiveSync>complete</adaptiveSync>
        </core>

        <theme>
          <cornerRadius>0</cornerRadius>
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
          <key key="W-p">
            <action name="Execute">
              <command>wlr-which-key</command>
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

    "labwc/autostart".text = ''
      systemctl --user set-environment XDG_CURRENT_DESKTOP=labwc && systemctl --user restart xdg-desktop-portal &
      swaynotificationcenter &
      nm-applet --indicator &
      blueman-applet &
      awww-daemon &
      vicinae server &
      vicinae set theme stylix &
    '';
  };

  home.packages = with pkgs; [
    wlr-which-key
  ];
}
