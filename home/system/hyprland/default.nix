{ pkgs, config, inputs, ... }:

let
  border-size = config.var.theme.border-size;
  gaps-in = config.var.theme.gaps-in;
  gaps-out = config.var.theme.gaps-out;
  active-opacity = config.var.theme.active-opacity;
  inactive-opacity = config.var.theme.inactive-opacity;
  rounding = config.var.theme.rounding;
  blur = config.var.theme.blur;
  keyboardLayout = config.var.keyboardLayout;
in {

  imports = [ ./animations.nix ./bindings.nix ./polkitagent.nix ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    hyprshot
    hyprpicker
    swappy
    imv
    wf-recorder
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome-themes-extra
    libva
    dconf
    wayland-utils
    wayland-protocols
    glib
    direnv
    meson
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    package = null;
    portalPackage = null;

    #plugins = [ inputs.hyprspace.packages.${pkgs.system}.Hyprspace ];

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      exec-once = [
        #"${pkgs.bitwarden}/bin/bitwarden"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        #SET Monitor to primary
        "xrandr --output eDP-1 --primary"
      ];

      plugin = { overview = { autoDrag = false; }; };

      monitor = [
        ",preferred,auto,1"
        "DP-1,highres,0x0,1,transform,3"
        "DP-4,highres,1440x0,1"
        "eDP-1,highres,4000x0,1.175"
      ];

      workspace = [
        #Lenovo
        "1,monitor:DP-1"
        "2,monitor:DP-1"
        "12,monitor:DP-1"
        "11,monitor:DP-4"
        #DELL
        "3,monitor:DP-4"
        "4,monitor:DP-4"
        "5,monitor:DP-4"
        "6,monitor:DP-4"
        "10,monitor:DP-4"
        "13,monitor:DP-4"
        "14,monitor:DP-4"
        #Laptop
        "7,monitor:eDP-1"
        "8,monitor:eDP-1"
        "15,monitor:DP-4"
      ];

      env = [
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "GDK_BACKEND,wayland,x11"
        "MOZ_ENABLE_WAYLAND,1"
        "ANKI_WAYLAND,1"
        "DISABLE_QT5_COMPAT,0"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "GTK_THEME,FlatColor:dark"
        "GTK2_RC_FILES,/home/noureddine/.local/share/themes/FlatColor/gtk-2.0/gtkrc" #CHANGEME
        "DISABLE_QT5_COMPAT,0"
        "DIRENV_LOG_FORMAT,"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "GDK_SCALE,1.175" #CHANGEME to what u made in monitor scaling
        "XCURSOR_SIZE,32"
        "WLR_DRM_NO_ATOMIC,1"
      ];

      xwayland  = {
        force_zero_scaling = true;
      };

      cursor = {
        no_hardware_cursors = true;
        default_monitor = "eDP-1";
      };

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        #border_part_of_window = true;
        layout = "master";
      };

      decoration = {
        shadow = { 
          enabled = true;
          #drop_shadow = true;
          #shadow_range = 20;
          #shadow_render_power = 3;
        };
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        blur = { enabled = if blur then "true" else "false"; };
      };

      dwindle = {
        force_split = 0;
        use_active_for_splits = true;
        pseudotile = true;
        preserve_split = true;
        smart_split = true;
      };

      master = {
        #new_status = true;
        allow_small_split = true;
        mfact = 0.5;
        new_status = "master";
        special_scale_factor = 1;
      };



      gestures = { workspace_swipe = true; };

#      gestures = {
#        workspace_swipe = true;
#        workspace_swipe_fingers = 3;
#        workspace_swipe_distance = 300;
#        workspace_swipe_invert = false;
#        workspace_swipe_min_speed_to_force = 30;
#      };

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      layerrule = [ "noanim, launcher" "noanim, ^ags-.*" ];

      input = {
        kb_layout = keyboardLayout;

        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.3;
        accel_profile = "adaptive";
        repeat_delay = 300;
        repeat_rate = 50;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          disable_while_typing = true;
          middle_button_emulation = false;
          tap-to-click = true;
          drag_lock = false;
          tap-and-drag = true;
        };
      };
    };
  };
  systemd.user.targets.hyprland-session.Unit.Wants =
    [ "xdg-desktop-autostart.target" ];
}
