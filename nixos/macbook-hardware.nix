# Configuration matérielle spécifique pour MacBook Air 2013
{ config, lib, pkgs, ... }:

{
  # Support matériel Apple
  hardware = {
    # Firmware propriétaires nécessaires pour le WiFi Broadcom
    enableRedistributableFirmware = true;
    
    # Support des capteurs Apple
    sensor.iio.enable = true;
    
    # Configuration graphique Intel
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    
    # Support Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    
    # Support du trackpad
    trackpad = {
      enable = true;
      naturalScrolling = true;
      tapToClick = true;
      clickMethod = "clickfinger";
      horizontalScrolling = true;
      disableAcceleration = false;
      sensitivity = "0.5";
    };
  };

  # Kernel et modules spécifiques
  boot = {
    # Kernel avec meilleur support MacBook
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Modules nécessaires pour MacBook
    initrd.kernelModules = [ 
      "i915"      # Intel graphics
      "hid_apple" # Clavier Apple
      "btusb"     # Bluetooth USB
    ];
    
    kernelModules = [ 
      "kvm-intel" 
      "wl"        # Broadcom WiFi
      "facetimehd" # Webcam (si disponible)
    ];
    
    # Paramètres kernel pour MacBook
    kernelParams = [
      "acpi_osi=Linux"
      "acpi_backlight=vendor"
      "i915.modeset=1"
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
    ];
    
    # Support EFI
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  # Services spécifiques MacBook
  services = {
    # Gestion de la luminosité
    illum.enable = true;
    
    # Support du clavier Apple
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              # Inverser Fn et Control sur clavier Apple
              leftcontrol = "fn";
              fn = "leftcontrol";
              # Touches de fonction par défaut (pas besoin de Fn)
              f1 = "brightnessdown";
              f2 = "brightnessup";
              f3 = "scale";
              f4 = "dashboard";
              f5 = "kbdillumdown";
              f6 = "kbdillumup";
              f7 = "previoussong";
              f8 = "playpause";
              f9 = "nextsong";
              f10 = "mute";
              f11 = "volumedown";
              f12 = "volumeup";
            };
          };
        };
      };
    };
    
    # Gestion de l'alimentation
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        
        # Optimisations pour MacBook
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;
        
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        
        # WiFi power management
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    };
    
    # Support du touchpad
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        horizontalScrolling = true;
      };
    };
    
    # Température et ventilateurs
    thermald.enable = true;
  };

  # Paquets supplémentaires pour MacBook
  environment.systemPackages = with pkgs; [
    # Outils de gestion MacBook
    brightnessctl
    light
    
    # Support webcam (si disponible)
    # facetimehd-firmware
    
    # Outils de diagnostic
    lm_sensors
    acpi
    powertop
    
    # Driver WiFi Broadcom
    broadcom-bt-firmware
  ];

  # Configuration du son
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    
    # Configuration spécifique MacBook
    config.pipewire = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 8192;
      };
    };
  };

  # Ajustements pour la batterie
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };
}