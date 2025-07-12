{ lib, pkgs, config, ... }: 
{
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 20;
      gaps-in = 10;
      gaps-out = 10 * 2;
      active-opacity = 0.96;
      inactive-opacity = 0.92;
      blur = true;
      border-size = 3;
      animation-speed = "fast"; # "fast" | "medium" | "slow"
      fetch = "none"; # "nerdfetch" | "neofetch" | "pfetch" | "none"
      textColorOnWallpaper =
        config.lib.stylix.colors.base01; # Color of the text displayed on the wallpaper (Lockscreen, display manager, ...)

      bar = { # Hyprpanel
        position = "top"; # "top" | "bottom"
        transparent = true;
        transparentButtons = false;
        floating = true;
      };
    };
    description = "Theme configuration options";
  };

  config.stylix = {
    # Activer stylix
    enable = true;

    # Image de fond d'écran
    image = ./wallpapers/city.png; #TODO random

    # Thème Rosé Pine Dawn
    base16Scheme = {
      base00 = "F9F5D7";
      base01 = "EBDBB2";
      base02 = "D5C4A1";
      base03 = "BDAE93";
      base04 = "665C54";
      base05 = "504945";
      base06 = "3C3836";
      base07 = "282828";
      base08 = "9D0006";
      base09 = "AF3A03";

      base0A = "B57614";
      base0B = "79740E";
      base0C = "427B58";
      base0D = "b8bb26";#076678
      base0E = "8F3F71";
      base0F = "D65D0E";

      primary = "d65d0e";    # Orange (utilisé pour les accents)
      secondary = "504945";  # Gris foncé (utilisé pour les arrière-plans secondaires)
      tertiary = "665c54";   # Gris moyen (utilisé pour certains textes)
      quaternary = "7c6f64"; 
    };

    # Configuration des polices
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.source-sans-pro;
        name = "Source Sans Pro";
      };
      serif = config.stylix.fonts.sansSerif;
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 13;
        terminal = 13;
      };
    };

    # Configuration du curseur
    #cursor = {
    #  package = pkgs.bibata-cursors;
    #  name = "Bibata-Modern-Ice";
    #  size = 24;
    #};

    cursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
    };

    polarity = "light";

    # Configuration Qt
    targets.qt.platform = lib.mkForce "qtct";

    # Configurations supplémentaires
    opacity = {
      terminal = 0.95;
      applications = 1.0;
      popups = 0.95;
    };
  };
}