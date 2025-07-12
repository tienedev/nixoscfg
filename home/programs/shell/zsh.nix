{ pkgs, lib, config, ... }:
let fetch = config.var.theme.fetch; # neofetch, nerdfetch, pfetch
in {

  imports = [
      ./gcp.nix
  ];

  home.packages = with pkgs; [ bat ripgrep tldr sesh ];

  home.sessionPath = [ "$HOME/go/bin" ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    initContent = lib.mkBefore ''
      bindkey -e
      ${if fetch == "neofetch" then
        pkgs.neofetch + "/bin/neofetch"
      else if fetch == "nerdfetch" then
        "nerdfetch"
      else if fetch == "pfetch" then
        "echo; ${pkgs.pfetch}/bin/pfetch"
      else
        ""}

      function sesh-sessions() {
        session=$(sesh list -t -c | fzf --height 70% --reverse)
        [[ -z "$session" ]] && return
        sesh connect $session
      }

      zle     -N             sesh-sessions
      bindkey -M emacs '\es' sesh-sessions
      bindkey -M vicmd '\es' sesh-sessions
      bindkey -M viins '\es' sesh-sessions
    '';

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };

    profileExtra = lib.optionalString (config.home.sessionPath != [ ]) ''
      export PATH="$PATH''${PATH:+:}${
        lib.concatStringsSep ":" config.home.sessionPath
      }"
    '';

    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      c = "clear";
      clera = "clear";
      celar = "clear";
      e = "exit";
      cd = "z";
      ls = "eza --icons=always --no-quotes";
      tree = "eza --icons=always --tree --no-quotes";
      sl = "ls";
      open = "${pkgs.xdg-utils}/bin/xdg-open";
      icat = "${pkgs.kitty}/bin/kitty +kitten icat";

      wireguard-import = "nmcli connection import type wireguard file";

      notes =
        "nvim ~/nextcloud/Notes/index.md --cmd 'cd ~/nextcloud/Notes' -c ':Telescope find_files'";
      note = "notes";

      # git
      ga = "git add";
      gc = "git commit";
      gcm = "git commit -m";
      gcu = "git add . && git commit -m 'Update'";
      gp = "git push";
      gpl = "git pull";
      gs = "git status";
      gd = "git diff";
      gco = "git checkout";
      gcb = "git checkout -b";
      gbr = "git branch";


      #services logs
      # Afficher les dernières lignes du journal home-manager
        hmlog = "journalctl -u home-manager-nixos.service -n 50 --no-pager";

        # Suivre en temps réel les nouvelles entrées
        hmlogf = "journalctl -u home-manager-nixos.service -f";

        # Afficher les journaux depuis le dernier boot
        hmlogb = "journalctl -u home-manager-nixos.service -b";

        # Afficher tous les journaux en commençant par la fin
        hmlogt = "journalctl -u home-manager-nixos.service --no-pager | tac";

        # Afficher uniquement les erreurs
        hmloge = "journalctl -u home-manager-nixos.service -p err..alert";
    };
  };
}
