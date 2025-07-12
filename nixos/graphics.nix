{ config, pkgs, ... }:
{

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;


    graphics.extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
        #vaapiIntel
      ];
  };
}