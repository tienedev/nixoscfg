{ config, lib, pkgs, ... }:

let
  tinkerwell = pkgs.appimageTools.wrapType2 {
    name = "tinkerwell";
    pname = "tinkerwell";
    version = "4.20.1";
    src = pkgs.fetchurl {
      url = "https://download.tinkerwell.app/tinkerwell/Tinkerwell-4.23.1.AppImage";
      # Utilisez `nix-prefetch-url --type sha256 URL` pour obtenir le hash correct
      sha256 = "11nkymgwfi61qk3yhl4cig65pczhw9jizincdn25m9ya3n0x876c";
    };
  };
in
{
  home.packages = [ tinkerwell ];


  xdg.desktopEntries.tinkerwell = {
    name = "Tinkerwell";
    exec = "tinkerwell";
    icon = "tinkerwell";
    comment = "The Swiss Army Knife for PHP Development";
    categories = [ "Development" ];
    type = "Application";
  };
}
