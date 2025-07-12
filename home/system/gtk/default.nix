{ config, pkgs, lib, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  foreground = "#${config.lib.stylix.colors.base05}";
  background = "#${config.lib.stylix.colors.base00}";
  background-alt = "#${config.lib.stylix.colors.base01}";

  c0 = "#${config.lib.stylix.colors.base00}";
  c1 = "#${config.lib.stylix.colors.base08}";
  c2 = "#${config.lib.stylix.colors.base0B}";
  c3 = "#${config.lib.stylix.colors.base0A}";
  c4 = "#${config.lib.stylix.colors.base0D}";
  c5 = "#${config.lib.stylix.colors.base0E}";
  c6 = "#${config.lib.stylix.colors.base0C}";
  c7 = "#${config.lib.stylix.colors.base05}";
  c8 = "#${config.lib.stylix.colors.base03}";
  c9 = "#${config.lib.stylix.colors.base08}";
  c10 = "#${config.lib.stylix.colors.base0B}";
  c11 = "#${config.lib.stylix.colors.base0A}";
  c12 = "#${config.lib.stylix.colors.base0D}";
  c13 = "#${config.lib.stylix.colors.base0E}";
  c14 = "#${config.lib.stylix.colors.base0C}";
  c15 = "#${config.lib.stylix.colors.base07}";

in {

  gtk = {
    enable = true;
    
    theme = lib.mkForce {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = lib.mkForce {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    font = {
      name = config.stylix.fonts.serif.name;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home.packages = with pkgs; [
    adw-gtk3
    adwaita-qt
    papirus-icon-theme
    gnome-themes-extra
    adwaita-icon-theme
  ];

  dconf.settings = lib.mkForce {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
    };
  };
}