{ pkgs, ... }: {
  # Enable GNOME Desktop Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Install GNOME packages
  environment.systemPackages = with pkgs; [
    #gnome.gnome-tweaks
    dconf-editor
    #gnome.adwaita-icon-theme
    #gnome.gnome-themes-extra
  ];

  # Enable required services for GNOME
  services.gnome.core-apps.enable = true;

  # Exclude some default GNOME applications to reduce clutter
  environment.gnome.excludePackages = with pkgs; [
    epiphany    # Web browser
    totem       # Video player
    cheese      # Webcam tool
    geary       # Email client
    tali        # Game
    iagno       # Game
    hitori      # Game
    atomix      # Game
  ];
}
