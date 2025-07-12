{ pkgs, inputs, ... }: {
  # Disable greetd/tuigreet as we're now using GDM
  services.greetd.enable = false;

  # Enable GDM and configure session options
  services.displayManager = {
    gdm = {
      enable = true;
      wayland = true; # Enable Wayland support in GDM
    };
    # Set default session to Hyprland
    defaultSession = "hyprland";
    # Ensure GDM can find and use Hyprland
    sessionPackages = [ pkgs.hyprland ];
  };

  # Enable Hyprland at the system level so it's recognized by GDM
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
