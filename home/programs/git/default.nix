{ pkgs, config, lib, ... }:
let
  username = config.var.git.username;
  email = config.var.git.email;
in {

  home.packages = with pkgs; [
    gitleaks
  ];

  # Variable d'environnement pour le token GitHub
  home.sessionVariables = {
    GITHUB_TOKEN_FILE = "/run/secrets/github_actual_token";
  };

  # Configuration automatique du token GitHub pour le compte pro
  home.activation.setupGitHub = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f /run/secrets/github_actual_token ]; then
      echo "Configuration du token GitHub pour le compte pro..."
      $DRY_RUN_CMD ${pkgs.gh}/bin/gh auth login --with-token < /run/secrets/github_actual_token || true
    fi
  '';

  programs.gh = {
       enable = true;
       settings = {
         git_protocol = "ssh";
         prompt = "enabled";
         aliases = {
           co = "pr checkout";
           pv = "pr view";
           pc = "pr create";
        };
      };
  };
  
  programs.git = {
    enable = true;
    # Configuration par défaut (compte perso)
    userName = username;  # tienedev
    userEmail = email;    # tienedev@gmail.com
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "*.elc"
      "auto-save-list"
      ".direnv/"
      "node_modules"
      "result"
      "result-*"
    ];
    
    # Configuration conditionnelle avec home-manager includes
    includes = [
      {
        condition = "gitdir:~/actualtysoft/";
        contents = {
          user = {
            name = "EtienneActual";
            email = "etienne.brun@groupactual.eu";
          };
          url = {
            "git@github.com-work:" = {
              insteadOf = "git@github.com:";
            };
          };
        };
      }
      {
        condition = "gitdir:~/actualtysoft/.git";
        contents = {
          user = {
            name = "EtienneActual";
            email = "etienne.brun@groupactual.eu";
          };
          url = {
            "git@github.com-work:" = {
              insteadOf = "git@github.com:";
            };
          };
        };
      }
    ];
    
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      
      # Configuration des URLs pour utiliser le bon compte SSH
      url."git@github.com-personal:tienedev/".insteadOf = "git@github.com:tienedev/";
      url."git@github.com-work:EtienneActual/".insteadOf = "git@github.com:EtienneActual/";
    };
    aliases = {
      essa = "push --force";
      co = "checkout";
      fuck = "commit --amend -m";
      c = "commit -m";
      ca = "commit -am";
      forgor = "commit --amend --no-edit";
      graph = "log --all --decorate --graph --oneline";
      oops = "checkout --";
      l = "log";
      r = "rebase";
      s = "status --short";
      ss = "status";
      d = "diff";
      ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
      pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
      af = "!git add $(git ls-files -m -o --exclude-standard | sk -m)";
      st = "status";
      br = "branch";
      df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
      hist = ''
        log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
      llog = ''
        log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
      edit-unmerged =
        "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
    };
  };

  # Fichiers de configuration SSH
  home.file = {
    ".ssh/config".text = ''
      # Configuration SSH pour gérer plusieurs comptes GitHub

      # Compte personnel (tienedev)
      Host github.com-personal
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes

      # Compte professionnel (EtienneActual) 
      Host github.com-work
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519_work
          IdentitiesOnly yes

      # Configuration par défaut pour GitHub (compte perso)
      Host github.com
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
    '';
  };
}
