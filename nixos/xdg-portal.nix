{ pkgs, ... }: {
  
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [ 
        pkgs.xdg-desktop-portal-hyprland 
        pkgs.xdg-desktop-portal-gtk
      ];
  };
}
