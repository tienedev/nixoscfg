{ pkgs, ... }: {
  
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals =
      [ 
        pkgs.xdg-desktop-portal-hyprland 
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gnome
      ];
  };
}
