{ pkgs, config, ... }:
let
  hostname = config.var.hostname;
  keyboardLayout = config.var.keyboardLayout;
in {

  networking.hostName = hostname;

  services = {
    xserver = {
      enable = true;
      xkb.layout = keyboardLayout;
      xkb.variant = "";
    };
    gnome.gnome-keyring.enable = true;
  };
  console.keyMap = keyboardLayout;

  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
   # EDITOR = "nvim"; # CHANGEME
    EDITOR = "nano";
    TERM = "kitty";
  };

  services.libinput.enable = true;
  programs.dconf.enable = true;
  services = {
    dbus.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    # power-profiles-daemon.enable = true; # Conflicts with TLP
    udisks2.enable = true;
  };

  # enable zsh autocompletion for system packages (systemd, etc)
  #environment.pathsToLink = [ "/share/zsh" ];


  # Faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  environment.systemPackages = with pkgs; [
    #hyprland-qtutils
    fd
    bc
    gcc
    git-ignore
    xdg-utils
    wget
    curl
  ];

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
