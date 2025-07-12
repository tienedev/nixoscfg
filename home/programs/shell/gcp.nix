{ pkgs, lib, config, ... }:
let
  # Google Cloud SDK avec le plugin GKE auth
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [ 
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin 
  ];
in
{
  home.packages = with pkgs; [
    coreutils
    gcloud
    kubectl
    curl
  ];

  # Script de switch GCP
  home.file.".local/bin/gcp-switch" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      gcp_dev() {
        echo "Switching to Development environment..."
        gcloud container clusters get-credentials app --zone europe-west1-d --project eactual-215607
        kubectl config set-context --current --namespace=default
        echo "Now using Development environment"
      }
      gcp_preprod() {
        echo "Switching to Pre-production environment..."
        gcloud container clusters get-credentials app --zone europe-west1-b --project eactual-preprod
        kubectl config set-context --current --namespace=default
        echo "Now using Pre-production environment"
      }
      gcp_prod() {
        echo "Switching to Production environment..."
        gcloud container clusters get-credentials app --zone europe-west1-b --project eactual-prod
        kubectl config set-context --current --namespace=default
        echo "Now using Production environment"
      }
      gcp_current() {
        echo "Current GCP configuration:"
        echo "------------------------"
        echo "Project: $(gcloud config get-value project)"
        echo "Zone: $(gcloud config get-value compute/zone)"
        echo "Cluster: $(kubectl config current-context)"
        echo "------------------------"
      }
    '';
  };

  # Configuration spécifique pour ZSH liée à GCP
  programs.zsh.initContent = ''
    # Source GCP functions
    source ~/.local/bin/gcp-switch
    # GCP environment aliases
    alias gdev='gcp_dev'
    alias gpreprod='gcp_preprod'
    alias gprod='gcp_prod'
    alias gcp-status='gcp_current'
    # GCP prompt info
    gcp_prompt_info() {
      local project=$(gcloud config get-value project 2>/dev/null)
      case "$project" in
        "eactual-215607") echo "%F{green}DEV%f";;
        "eactual-preprod") echo "%F{yellow}PRE%f";;
        "eactual-prod") echo "%F{red}PROD%f";;
        *) echo "";;
      esac
    }
    # Ajout de l'info GCP au prompt existant
    PS1='$(gcp_prompt_info)'$PS1
  '';
}