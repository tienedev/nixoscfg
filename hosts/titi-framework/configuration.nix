{ config, ... }: {
  imports = [

    ../../nixos/audio.nix
    ../../nixos/graphics.nix
    ../../nixos/auto-upgrade.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/network-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/timezone.nix
    ../../nixos/tuigreet.nix
    ../../nixos/docker.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/xdg-portal.nix
    ../../nixos/variables-config.nix
    # ../../nixos/gnome.nix  # Removed: Using Hyprland instead
    ../../nixos/hosts-config.nix
    
    ../../nixos/framework-optimizations.nix

    # Choose your theme here
    ../../themes/nixy.nix
    #../../themes/gruvbox.nix
    #../../themes/pinky.nix
    #../../themes/gruvbox-dark.nix
    #../../themes/rose-pine.nix

    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
