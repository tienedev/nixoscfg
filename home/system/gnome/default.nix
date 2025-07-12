{ pkgs, lib, config, ... }:

{
  # Enable GNOME-specific home-manager modules
  dconf.settings = {
    # Customize GNOME settings
    "org/gnome/desktop/interface" = {
      #color-scheme = "prefer-dark"; //TODO: check why conflicting definition values
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "slight";
      #gtk-theme = "Adwaita-dark";
      #cursor-theme = "Adwaita"; # Géré par stylix
      icon-theme = "Adwaita";
    };

    # Configure window manager behavior
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      focus-mode = "click";
      num-workspaces = 4;
    };

    # Configure keybindings
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
    };

    # Configure GNOME Shell extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "kitty.desktop"
        "code.desktop"
      ];
    };

    # Configure GNOME Terminal
    "org/gnome/terminal/legacy" = {
      theme-variant = "dark";
    };
  };

  # Install GNOME Shell extensions
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    dash-to-dock
    user-themes
  ];
}
