{ config, lib, pkgs, ... }:

let
  memos-pwa = pkgs.writeShellScriptBin "memos-pwa" ''
    ${pkgs.google-chrome}/bin/google-chrome-stable --app="https://memos.ramdi.fr" \
      --class="Memos" \
      --user-data-dir="$HOME/.config/memos-pwa" \
      --no-first-run \
      --no-default-browser-check \
      "$@"
  '';
in
{
  home.packages = [
    memos-pwa
    pkgs.google-chrome
  ];


  xdg.desktopEntries.memos-pwa = {
    name = "Memos";
    exec = "memos-pwa";
    icon = "web-browser";
    comment = "Memos App PWA";
    categories = [ ];
    type = "Application";
    
    settings = {
      StartupWMClass = "Memos";
      Keywords = "note;memos;";
    };
  };

  # Configuration des permissions du navigateur (optionnel)
  home.file.".config/memos-pwa/Default/Preferences".text = builtins.toJSON {
    browser = {
      enabled_labs_experiments = [
        "enable-desktop-pwas"
        "enable-desktop-pwas-without-extensions"
      ];
    };
    profile = {
      default_content_setting_values = {
        notifications = 1;
      };
    };
  };
}