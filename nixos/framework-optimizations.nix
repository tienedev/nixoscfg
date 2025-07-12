# Optimisations supplémentaires pour Framework Laptop 12th Gen Intel
{ config, lib, pkgs, ... }:

{
  # Optimisations CPU Intel 12th gen (P-cores et E-cores)
  boot.kernelParams = [
    # Meilleure gestion des P-cores et E-cores
    "intel_pstate=active"
    
    # Support du deep sleep
    "mem_sleep_default=deep"
    
    # Optimisations graphiques Intel Xe
    "i915.enable_psr=2"
    "i915.enable_fbc=1"
  ];

  # Power management Framework laptop
  services.tlp = {
    enable = true;
    settings = {
      # Optimisations CPU
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      
      # Intel GPU
      INTEL_GPU_MIN_FREQ_ON_AC = 350;
      INTEL_GPU_MIN_FREQ_ON_BAT = 350;
      INTEL_GPU_MAX_FREQ_ON_AC = 1450;
      INTEL_GPU_MAX_FREQ_ON_BAT = 800;
      
      # Optimisations USB/Thunderbolt
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;
      
      # Optimisations WiFi Intel AX210
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      
      # PCIe ASPM
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersave";
      
      # Framework laptop specific
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  # Framework keyboard & trackpad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";
      disableWhileTyping = true;
    };
  };

  # Support des touches fonction Framework
  services.keyd = {
    enable = true;
    keyboards = {
      framework = {
        ids = [ "*" ];
        settings = {
          main = {
            # Touches fonction Framework laptop
            f1 = "f1";  # Par défaut F1-F12 sont des F keys
            f2 = "f2";  # Utiliser Fn pour les actions media
            f3 = "f3";
            f4 = "f4";
            f5 = "f5";
            f6 = "f6";
            f7 = "f7";
            f8 = "f8";
            f9 = "f9";
            f10 = "f10";
            f11 = "f11";
            f12 = "f12";
            
            # Framework key (gear icon) → Super
            # leftmeta = "leftmeta";
          };
        };
      };
    };
  };

  # Capteur de luminosité ambiante
  hardware.sensor.iio.enable = true;

  # Support du capteur d'empreinte (si présent)
  services.fprintd.enable = true;

  # Optimisations thermiques
  services.thermald = {
    enable = true;
    configFile = pkgs.writeText "thermal-conf.xml" ''
      <?xml version="1.0"?>
      <ThermalConfiguration>
        <Platform>
          <Name>Framework Laptop 12th Gen</Name>
          <ProductName>Laptop 12th Gen Intel Core</ProductName>
          <Preference>QUIET</Preference>
          <ThermalZones>
            <ThermalZone>
              <Type>auto</Type>
              <TripPoints>
                <TripPoint>
                  <Temperature>75000</Temperature>
                  <type>passive</type>
                </TripPoint>
                <TripPoint>
                  <Temperature>85000</Temperature>
                  <type>max</type>
                </TripPoint>
              </TripPoints>
            </ThermalZone>
          </ThermalZones>
        </Platform>
      </ThermalConfiguration>
    '';
  };

  # Firmware updates Framework
  services.fwupd = {
    enable = true;
    # Framework pousse des updates firmware réguliers
  };

  # Optimisations audio pour Framework
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    
    # Configuration optimisée pour le DAC Framework
    # Note: config.pipewire est obsolète dans NixOS unstable
    # TODO: Migrer vers la nouvelle syntaxe pipewire quand documentée
  };

  # Support des modules d'extension Framework
  # Les modules USB-C sont automatiquement détectés
  # services.udev.packages = [ pkgs.framework-laptop-kmod ]; # Package n'existe pas dans nixpkgs

  # Outils spécifiques Framework
  environment.systemPackages = with pkgs; [
    # framework-tool        # CLI pour gérer le firmware (n'existe pas dans nixpkgs)
    intel-gpu-tools      # Pour débugger Intel Xe
    nvme-cli            # Pour gérer le SSD NVMe
    powertop            # Analyse de consommation
    s-tui               # Monitoring thermique
    intel-media-driver  # Accélération vidéo
  ];
}