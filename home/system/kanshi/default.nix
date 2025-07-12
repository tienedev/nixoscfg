{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 1.25;
            status = "enable";
            mode = "2560x1600@60";
            position = "0,0";
          }
        ];
        exec = [
           "wlr-randr --output eDP-1 --scale 1.25"
        ];
      };

      laptop_docked_dp = {
        outputs = [
          {
            criteria = "DP-1";
            mode = "2560x1440@143.912003";
            position = "0,0";
            status = "enable";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
        exec = [
           "wlr-randr --output DP-1 --mode \"2560x1440@143.912003\" --output eDP-1 --off"
        ];
      };

      laptop_docked_hdmi = {
        outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            mode = "2560x1440@144";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
        exec = [
           "wlr-randr --output HDMI-A-1 --mode \"2560x1440@143.912003\" --output eDP-1 --off"
        ];
      };
    };
  };
}