{ config, ... }: {
  imports = [ ../../nixos/variables-config.nix ];

  config.var = {
    hostname = "titi-framework";
    username = "titi";
    configDirectory = "/home/" + config.var.username
      + "/.config/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "fr";

    location = "Genova, Italy";
    apikey = "4c060600bc474249931220539242310";
    timeZone = "Europe/Rome";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "it_IT.UTF-8";

    git = {
      username = "tienedev";
      email = "tienedev@gmail.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = false;

    theme = {
      rounding = 15;
      gaps-in = 10;
      gaps-out = 10 * 2;
      active-opacity = 1;
      inactive-opacity = 0.89;
      blur = true;
      border-size = 3;
      animation-speed = "medium"; # "fast" | "medium" | "slow"
      fetch = "nerdfetch"; # "nerdfetch" | "neofetch" | "pfetch" | "none"

      bar = {
        transparent = true;
        floating = true;
      };
    };
  };
}
