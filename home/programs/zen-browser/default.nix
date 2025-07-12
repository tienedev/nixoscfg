{ config, lib, pkgs, ... }:

let
  zen-browser = pkgs.appimageTools.wrapType2 {
    name = "zen-browser";
    pname = "zen-browser";
    version = "4.20.1";
    src = pkgs.fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/1.0.1-a.14/zen-specific.AppImage";
      
      sha256 = "01ccmxrgl20s40v97c10fkj9mdscj3rq781hcpz6bwz0b4izj4l3";
    };
  };
in
{
  home.packages = [ zen-browser ];


  xdg.desktopEntries.zen-browser = {
    name = "zen-browser";
    exec = "zen-browser";
    icon = "zen-browser";
    comment = "The browser made for your";
    categories = [ "Development" ];
    type = "Application";
  };
}