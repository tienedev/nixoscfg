{ config, ... }: {
  imports = [

    ../../nixos/audio.nix
    ../../nixos/graphics.nix
    ../../nixos/auto-upgrade.nix
    # ../../nixos/bluetooth.nix  # Géré dans macbook-hardware.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/network-manager.nix
    ../../nixos/nix.nix
    # ../../nixos/systemd-boot.nix  # Géré dans macbook-hardware.nix
    ../../nixos/timezone.nix
    ../../nixos/tuigreet.nix
    ../../nixos/docker.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    #../../nixos/printers.nix #CHANGEME only if have the same printer
    ../../nixos/xdg-portal.nix
    ../../nixos/variables-config.nix
    ../../nixos/gnome.nix
    ../../nixos/hosts-config.nix #TODO: move this to Actual config
    
    # Configuration spécifique MacBook
    ../../nixos/macbook-hardware.nix

    # Choose your theme here
    #../../themes/nixy.nix
    ../../themes/gruvbox.nix
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
