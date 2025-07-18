# 🔐 Guide Sops-nix : Gestion des Secrets

## 📋 Table des matières

1. [Introduction](#introduction)
2. [Installation et Configuration](#installation-et-configuration)
3. [Utilisation Quotidienne](#utilisation-quotidienne)
4. [Cas d'Usage](#cas-dusage)
5. [Dépannage](#dépannage)
6. [Sécurité](#sécurité)

## Introduction

### Qu'est-ce que Sops-nix ?

**Sops-nix** combine deux outils puissants :
- **SOPS** (Secrets OPerationS) : Chiffre/déchiffre des fichiers YAML/JSON
- **age** : Outil de chiffrement moderne et simple
- **nix** : Intégration transparente dans NixOS

### Pourquoi utiliser Sops-nix ?

✅ **Avantages** :
- Secrets versionnés dans Git (chiffrés)
- Déchiffrement automatique au démarrage
- Permissions granulaires par secret
- Pas de secrets en clair dans le Nix store

❌ **Sans Sops-nix** :
```nix
# MAUVAIS : Secret visible dans le store
services.myapp.apiKey = "sk-1234567890abcdef";
```

✅ **Avec Sops-nix** :
```nix
# BON : Secret chiffré, déchiffré uniquement à l'exécution
services.myapp.apiKeyFile = config.sops.secrets.myapp_api_key.path;
```

## Installation et Configuration

### 1. Configuration initiale (déjà fait)

Le module sops-nix est déjà configuré dans votre système :

```nix
# flake.nix
inputs.sops-nix.url = "github:Mic92/sops-nix";

# hosts/*/configuration.nix
imports = [ ../../nixos/sops.nix ];
```

### 2. Génération de la clé age

Si vous n'avez pas encore de clé :

```bash
# Générer une nouvelle clé
age-keygen -o ~/.config/sops/age/keys.txt

# Afficher votre clé publique
age-keygen -y ~/.config/sops/age/keys.txt
```

### 3. Configuration `.sops.yaml`

Ce fichier définit qui peut déchiffrer quoi :

```yaml
keys:
  # Votre clé publique age
  - &titi age1wvx404flwc4zsx84zzpkd48zvktfw4vfuxy2h7auqrfy9k0hvsms4ygwdt
  
creation_rules:
  # Règle par défaut pour tous les secrets
  - path_regex: secrets/.*\.yaml$
    key_groups:
      - age:
          - *titi
          
  # Règle spécifique par machine (optionnel)
  - path_regex: hosts/laptop/secrets/.*\.yaml$
    key_groups:
      - age:
          - *titi
          # - *autre_machine  # Si multi-machines
```

## Utilisation Quotidienne

### Ajouter un nouveau secret

1. **Éditer le fichier de secrets** :
```bash
cd ~/.config/nixos
sops secrets/secrets.yaml
```

2. **Ajouter votre secret** dans l'éditeur :
```yaml
# Secrets d'API
github_token: "ghp_xxxxxxxxxxxxxxxxxxxx"
openai_api_key: "sk-xxxxxxxxxxxxxxxxxxxxxxxx"

# Mots de passe
wifi_password: "MonMotDePasseWiFi"
nextcloud_admin_pass: "MotDePasseComplexe123!"

# Certificats (multi-lignes)
vpn_cert: |
  -----BEGIN CERTIFICATE-----
  MIIFKzCCBBOgAwIBAgIUE7XYLJNg7...
  -----END CERTIFICATE-----
```

3. **Déclarer le secret dans `nixos/sops.nix`** :
```nix
sops.secrets = {
  github_token = {
    owner = config.var.username;
    mode = "0400";  # Lecture seule pour le propriétaire
  };
  
  wifi_password = {
    owner = "root";
    group = "networkmanager";
    mode = "0440";  # Lecture pour root et groupe
  };
  
  vpn_cert = {
    owner = "root";
    path = "/etc/openvpn/cert.pem";  # Chemin personnalisé
    mode = "0400";
  };
};
```

4. **Rebuild** :
```bash
nixy rebuild
```

### Utiliser les secrets

#### Dans la configuration NixOS

```nix
# Exemple 1 : Service avec fichier de secret
services.nextcloud = {
  enable = true;
  adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;
};

# Exemple 2 : Variable d'environnement
systemd.services.myapp = {
  environment.API_KEY_FILE = config.sops.secrets.myapp_api_key.path;
  script = ''
    export API_KEY=$(cat $API_KEY_FILE)
    exec myapp
  '';
};

# Exemple 3 : NetworkManager
networking.wireless.networks = {
  "MonWiFi" = {
    pskRaw = "ext:${config.sops.secrets.wifi_password.path}";
  };
};
```

#### Dans Home Manager

```nix
# home/programs/git/default.nix
{ config, lib, pkgs, ... }:
{
  # Configuration GitHub CLI avec token
  home.activation.setupGitHub = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f /run/secrets/github_token ]; then
      $DRY_RUN_CMD ${pkgs.gh}/bin/gh auth login --with-token < /run/secrets/github_token
    fi
  '';
  
  # Ou via variable d'environnement
  home.sessionVariables = {
    GITHUB_TOKEN_FILE = "/run/secrets/github_token";
  };
}
```

#### Dans des scripts

```bash
#!/usr/bin/env bash
# Script utilisant un secret

# Méthode 1 : Lire directement
API_KEY=$(cat /run/secrets/openai_api_key)

# Méthode 2 : Vérifier l'existence
if [ -f /run/secrets/github_token ]; then
  export GITHUB_TOKEN=$(cat /run/secrets/github_token)
else
  echo "Erreur : Token GitHub non trouvé"
  exit 1
fi

# Utilisation
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/user
```

## Cas d'Usage

### 1. Tokens d'API

```yaml
# secrets/secrets.yaml
github_token: "ghp_xxxx"
gitlab_token: "glpat-xxxx"
openai_key: "sk-xxxx"
anthropic_key: "sk-ant-xxxx"
```

```nix
# nixos/sops.nix
sops.secrets = {
  github_token = { owner = config.var.username; };
  gitlab_token = { owner = config.var.username; };
  openai_key = { owner = config.var.username; };
  anthropic_key = { owner = config.var.username; };
};
```

### 2. Mots de passe WiFi

```yaml
# secrets/secrets.yaml
wifi_home: "MotDePasseMaison"
wifi_work: "MotDePasseTravail"
```

```nix
# configuration.nix
networking.networkmanager.enable = true;

# Ou avec wpa_supplicant
networking.wireless.networks = {
  "SSID-Maison" = {
    pskRaw = "ext:${config.sops.secrets.wifi_home.path}";
  };
};
```

### 3. Clés SSH privées

```yaml
# secrets/secrets.yaml
ssh_key_github: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAA...
  -----END OPENSSH PRIVATE KEY-----
```

```nix
sops.secrets.ssh_key_github = {
  owner = config.var.username;
  path = "/home/${config.var.username}/.ssh/id_github";
  mode = "0600";
};
```

### 4. Bases de données

```yaml
# secrets/secrets.yaml
postgres_password: "MotDePassePostgres"
mysql_root_password: "MotDePasseMySQL"
```

```nix
services.postgresql = {
  enable = true;
  initialScript = pkgs.writeText "init.sql" ''
    ALTER USER postgres PASSWORD '$(cat ${config.sops.secrets.postgres_password.path})';
  '';
};
```

### 5. Certificats SSL

```yaml
# secrets/secrets.yaml
ssl_cert: |
  -----BEGIN CERTIFICATE-----
  MIIFKzCCBBOgAwIBAgIUE7XYLJNg7...
  -----END CERTIFICATE-----
ssl_key: |
  -----BEGIN PRIVATE KEY-----
  MIIEvwIBADANBgkqhkiG9w0BAQEFA...
  -----END PRIVATE KEY-----
```

```nix
services.nginx = {
  virtualHosts."example.com" = {
    sslCertificate = config.sops.secrets.ssl_cert.path;
    sslCertificateKey = config.sops.secrets.ssl_key.path;
  };
};
```

## Dépannage

### Problèmes courants

#### "config file not found"
```bash
# Assurez-vous d'être dans le bon répertoire
cd ~/.config/nixos
sops secrets/secrets.yaml
```

#### "no keys found"
```bash
# Vérifiez que votre clé existe
ls ~/.config/sops/age/keys.txt

# Régénérez si nécessaire
age-keygen -o ~/.config/sops/age/keys.txt
```

#### Secret non accessible après rebuild
```bash
# Vérifiez que le secret est déchiffré
sudo ls -la /run/secrets/

# Vérifiez les logs
sudo journalctl -u sops-install-secrets
```

#### Permission denied
```bash
# Vérifiez les permissions dans sops.nix
sops.secrets.mon_secret = {
  owner = "user";      # Propriétaire
  group = "group";     # Groupe
  mode = "0400";       # Permissions (lecture seule ici)
};
```

### Commandes utiles

```bash
# Voir tous les secrets disponibles
sudo ls -la /run/secrets/

# Vérifier le contenu d'un secret (attention !)
sudo cat /run/secrets/github_token

# Recharger les secrets manuellement
sudo systemctl restart sops-install-secrets

# Débugger sops
sops -d secrets/secrets.yaml  # Déchiffrer manuellement

# Tourner la clé (changer de clé)
sops rotate -i secrets/secrets.yaml
```

## Sécurité

### ✅ Bonnes pratiques

1. **Ne jamais committer** :
   - Clés privées (`~/.config/sops/age/keys.txt`)
   - Fichiers déchiffrés
   - Anciens secrets non chiffrés

2. **Gitignore approprié** :
   ```gitignore
   # .gitignore
   keys.txt
   *.dec
   *.decrypted
   *_unencrypted.yaml
   ```

3. **Permissions strictes** :
   ```nix
   # Toujours utiliser le mode le plus restrictif possible
   sops.secrets.api_key = {
     mode = "0400";  # Lecture seule pour le propriétaire
   };
   ```

4. **Rotation régulière** :
   ```bash
   # Tous les 3-6 mois
   sops rotate -i secrets/secrets.yaml
   ```

### 🚨 À éviter

```nix
# ❌ MAUVAIS : Secret en clair
environment.variables.API_KEY = "sk-1234";

# ❌ MAUVAIS : Secret dans le store
services.app.configFile = pkgs.writeText "config" ''
  api_key = "sk-1234"
'';

# ✅ BON : Utiliser sops
services.app.apiKeyFile = config.sops.secrets.api_key.path;
```

### Multi-utilisateurs / Multi-machines

Pour partager des secrets entre plusieurs personnes/machines :

```yaml
# .sops.yaml
keys:
  - &alice age1alice...
  - &bob age1bob...
  - &laptop age1laptop...
  - &server age1server...

creation_rules:
  - path_regex: secrets/shared/.*\.yaml$
    key_groups:
      - age: [*alice, *bob, *laptop, *server]
        
  - path_regex: secrets/alice/.*\.yaml$
    key_groups:
      - age: [*alice, *laptop]
```

## Exemples avancés

### Template avec secrets

```nix
# Générer un fichier de config avec des secrets
environment.etc."myapp/config.toml".source = 
  pkgs.substituteAll {
    src = ./config.toml.template;
    api_key = "$(cat ${config.sops.secrets.api_key.path})";
    db_pass = "$(cat ${config.sops.secrets.db_password.path})";
  };
```

### Service systemd avec secrets

```nix
systemd.services.backup = {
  serviceConfig = {
    Type = "oneshot";
    LoadCredential = [
      "ssh_key:${config.sops.secrets.backup_ssh_key.path}"
      "encryption_key:${config.sops.secrets.backup_encryption_key.path}"
    ];
  };
  script = ''
    # Les secrets sont disponibles dans $CREDENTIALS_DIRECTORY
    export SSH_KEY=$CREDENTIALS_DIRECTORY/ssh_key
    export ENCRYPTION_KEY=$CREDENTIALS_DIRECTORY/encryption_key
    
    # Faire le backup...
  '';
};
```

### Hook d'activation Home Manager

```nix
home.activation.setupSecrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
  # Configuration AWS CLI
  if [ -f /run/secrets/aws_credentials ]; then
    mkdir -p ~/.aws
    cp /run/secrets/aws_credentials ~/.aws/credentials
    chmod 600 ~/.aws/credentials
  fi
  
  # Configuration SSH
  if [ -f /run/secrets/ssh_config ]; then
    mkdir -p ~/.ssh
    cp /run/secrets/ssh_config ~/.ssh/config
    chmod 600 ~/.ssh/config
  fi
'';
```

## Ressources

- [Sops-nix GitHub](https://github.com/Mic92/sops-nix)
- [Documentation SOPS](https://github.com/mozilla/sops)
- [age encryption](https://github.com/FiloSottile/age)
- [NixOS Wiki - Secrets](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes)

---

💡 **Astuce** : Commencez petit avec un ou deux secrets, puis étendez progressivement votre utilisation !