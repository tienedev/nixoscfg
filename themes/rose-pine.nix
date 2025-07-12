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
    image = ./wallpapers/1261770.png; #TODO random

    # Thème Rosé Pine Dawn
    base16Scheme = {
      base00 = "faf4ed"; # base
      base01 = "fffaf3"; # surface
      base02 = "f2e9e1"; # overlay
      base03 = "9893a5"; # muted
      base04 = "797593"; # subtle
      base05 = "575279"; # text
      base06 = "575279"; # highlight high
      base07 = "cecacd"; # highlight med
      base08 = "b4637a"; # love
      base09 = "ea9d34"; # gold
      base0A = "d7827e"; # rose
      base0B = "286983"; # pine
      base0C = "56949f"; # foam
      base0D = "907aa9"; # iris
      base0E = "ea9d34"; # gold
      base0F = "cecacd"; # highlight low
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

    polarity = "dark";

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