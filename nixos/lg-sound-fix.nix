{ config, lib, pkgs, ... }:

let
  username = "noureddine";
  soundScript = "/home/${username}/.config/scripts/lg-sound-fix.sh";
in
{
  environment.systemPackages = with pkgs; [
    alsa-utils
    alsa-tools
  ];

  services.dbus = {
    enable = true;
    implementation = "broker";
  };


  systemd.services.lg-sound-fix = {
    description = "LG Gram speaker initialization";
    wantedBy = [ "default.target" ];
    after = [ "sound.target" "alsa-store.service" ];
    path = [ pkgs.alsa-utils ];
    
    serviceConfig = {
      Type = "oneshot";
      ExecStart = soundScript;
      RemainAfterExit = true;
      Restart = "on-failure";
      User = "root";
    };
  };

  system.activationScripts = {
    lg-sound-fix = {
      text = ''
        mkdir -p /home/${username}/.config/scripts
        cp ${../home/scripts/sounds/lg-sound-fix.sh} ${soundScript}
        chmod +x ${soundScript}
        chown ${username}:users ${soundScript}
      '';
    };
  };
}