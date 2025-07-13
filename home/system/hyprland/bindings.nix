{ pkgs, ... }: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mod,T, exec, ${pkgs.kitty}/bin/kitty" # Kitty
      "$mod,G, exec, ${pkgs.google-chrome}/bin/google-chrome-stable" # Google Chrome
      "$mod,E, exec, ${pkgs.nautilus}/bin/nautilus" # nautilus
      "$mod,Y, exec, ${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi" # Yazi
      "$mod,K, exec, ${pkgs.bitwarden}/bin/bitwarden" # Bitwarden
      "$mod,L, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock
      "$mod,V, exec, code" # VS Code
      "$mod,X, exec, powermenu" # Powermenu
      "$mod,SPACE, exec, menu" # Launcher
      "$shiftMod,SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus
      #"$mod,TAB, overview:toggle" # Overview

      "$mod,Q, killactive," # Close window
      "$mod,RETURN, togglefloating," # Toggle Floating
      "$mod,F, fullscreen" # Toggle Fullscreen
      "$mod,left, movefocus, l" # Move focus left
      "$mod,right, movefocus, r" # Move focus Right
      "$mod,up, movefocus, u" # Move focus Up
      "$mod,down, movefocus, d" # Move focus Down
      "$shiftMod,up, focusmonitor, -1" # Focus previous monitor
      "$shiftMod,down, focusmonitor, 1" # Focus next monitor
      "$shiftMod,left, layoutmsg, addmaster" # Add to master
      "$shiftMod,right, layoutmsg, removemaster" # Remove from master

      "$mod,PRINT, exec, screenshot window" # Screenshot window
      ",PRINT, exec, screenshot monitor" # Screenshot monitor
      "$shiftMod,PRINT, exec, screenshot region" # Screenshot region
      "ALT,PRINT, exec, screenshot region swappy" # Screenshot region then edit

      "$shiftMod,S, exec, ${pkgs.google-chrome}/bin/google-chrome-stable :open $(wofi --show dmenu -L 1 -p ' Search on internet')" # Search on internet with wofi //TODO
      "$shiftMod,C, exec, clipboard" # Clipboard picker with wofi
      "$shiftMod,E, exec, ${pkgs.wofi-emoji}/bin/wofi-emoji" # Emoji picker with wofi
      "$mod,F2, exec, night-shift" # Toggle night shift
      "$mod,F3, exec, night-shift" # Toggle night shift

      # Navigation entre workspaces avec SUPER + flèches/arrows keyboard
      "$shiftMod, right, workspace, e+1"
      "$shiftMod, left, workspace, e-1"

      #binding F1-F12 workspace
      "$mod SHIFT, F1, movetoworkspace, 10"
      "$mod SHIFT, F2, movetoworkspace, 11"
      "$mod SHIFT, F3, movetoworkspace, 12"
      "$mod SHIFT, F4, movetoworkspace, 13"
      "$mod SHIFT, F5, movetoworkspace, 14"
      "$mod SHIFT, F6, movetoworkspace, 15"
      "$mod SHIFT, F7, movetoworkspace, 16"
      "$mod SHIFT, F8, movetoworkspace, 17"
      "$mod SHIFT, F9, movetoworkspace, 18"
      "$mod SHIFT, F10, movetoworkspace, 19"
      "$mod SHIFT, F11, movetoworkspace, 20"
      "$mod SHIFT, F12, movetoworkspace, 21"

      
    ] ++ (builtins.concatLists (builtins.genList (i:
      let ws = i + 1;
      in [
        "$mod,code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
      ]) 9));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
      ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      ",XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
      ",XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
    ];

  };
}
