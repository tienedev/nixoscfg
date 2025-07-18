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
      
      # Clés SSH
      ssh_key_personal = {
        owner = config.var.username;
        path = "/home/${config.var.username}/.ssh/id_ed25519";
        mode = "0600"; # Lecture/écriture pour le propriétaire uniquement
      };
      
      ssh_key_work = {
        owner = config.var.username;
        path = "/home/${config.var.username}/.ssh/id_ed25519_work";
        mode = "0600";
      };
    };
  };
}