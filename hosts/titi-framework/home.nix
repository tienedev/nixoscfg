{ pkgs, config, ... }:
{

  imports = [
    ./variables.nix

    # Programs
    ../../home/programs/kitty
    #../../home/programs/ghostty
    ../../home/programs/chromium
    #../../home/programs/nvim
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    ../../home/programs/yazi
    ../../home/programs/markdown
    ../../home/programs/thunar
    ../../home/programs/vscode
    ../../home/programs/claude-code
    ../../home/programs/gemini-cli
    ../../home/programs/task-master-ai
    ../../home/programs/tinkerwell
    ../../home/programs/zen-browser
    ../../home/programs/docker
    ../../home/programs/nautilus

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/hypridle
    #../../home/system/gtk
    ../../home/system/hyprlock
    ../../home/system/hyprpanel
    ../../home/system/hyprpaper
    #../../home/system/hyprswitch
    #../../home/system/kanshi
    ../../home/system/wofi
    ../../home/system/batsignal
    ../../home/system/zathura
    ../../home/system/mime
    ../../home/system/udiskie
    ../../home/system/clipman
    # ../../home/system/gnome  # Removed: Using Hyprland instead

  ];

  # Fix Qt and stylix warnings
  stylix.targets.qt.platform = "qtct";

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Apps
      discord
      youtube-music
      vlc
      tenacity

      # Dev
      go
      rustc
      nodejs
      python3
      python313Packages.pip
      pipx
      jq
      figlet
      hyperfine
      fd
      ripgrep
      bun
      katana #crawling

      #AI
      ollama
      lmstudio

      # Utils
      fast-cli
      yazi
      localsend
      zip
      unzip
      optipng
      pfetch
      pandoc
      btop
      onefetch
      kitty
      pciutils
      filezilla
      headscale
      virt-manager
      snapshot
      libreoffice
      gnumake42
      powertop
      netclient
      networkmanager
      wireguard-tools
      wireguard-ui

      #flameshot #screenshot

      #editor
      gedit

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix
      cava

      # Backup
      google-chrome
      neovide

      #monitor
      sysstat
      procps

      #chat
      slack


      #video sharing
      #libsForQt5.xwaylandvideobridge

      pipewire
      wireplumber
      grim
      slurp

      #android
      scrcpy
    ];

    # Import my profile picture, used by the hyprpanel dashboard
    file.".profile_picture.png" = { source = ./profile_picture.png; };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
