{ config, ... }:
{
  # Note: L'import de sops-nix doit se faire dans flake.nix
  
  sops = {
    # Fichier de secrets par défaut
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    age = {
      # Chemin vers votre clé privée age
      keyFile = "/home/${config.var.username}/.config/sops/age/keys.txt";
      
      # Génération automatique de la clé si elle n'existe pas
      generateKey = true;
    };
    
    # Déclaration des secrets
    secrets = {
      github_actual_token = {
        owner = config.var.username;
        mode = "0400"; # Lecture seule pour le propriétaire
      };
    };
  };
}