# Guide de Migration Ubuntu vers NixOS

Ce guide vous accompagne étape par étape pour migrer d'Ubuntu vers NixOS en utilisant la configuration Nixy.

## 📋 Pré-requis

### 1. Sauvegarde de vos données
Avant de commencer, assurez-vous de sauvegarder :
- Vos documents personnels (`~/Documents`, `~/Pictures`, etc.)
- Vos configurations importantes (`.ssh/`, `.gnupg/`, etc.)
- Liste des applications installées : `apt list --installed > ~/ubuntu-packages.txt`
- Vos dotfiles personnalisés

### 2. Matériel requis
- Une clé USB d'au moins 4GB
- 30GB minimum d'espace disque libre
- Connexion internet stable

## 🚀 Installation de NixOS

### Étape 1 : Créer une clé USB bootable

```bash
# Télécharger l'ISO NixOS minimal
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# Identifier votre clé USB (soyez très prudent!)
lsblk

# Créer la clé bootable (remplacer /dev/sdX par votre clé USB)
sudo dd if=latest-nixos-minimal-x86_64-linux.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Étape 2 : Partitionnement

Démarrez sur la clé USB et préparez vos partitions :

```bash
# Pour UEFI (recommandé)
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary 512MB 100%

# Formater les partitions
mkfs.fat -F32 -n BOOT /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

# Monter les partitions
mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

### Étape 3 : Installation de base

```bash
# Générer la configuration initiale
nixos-generate-config --root /mnt

# Installer git
nix-env -iA nixos.git

# Cloner cette configuration
cd /mnt/home
git clone https://github.com/anotherhadi/nixy.git nixos-config
```

## ⚙️ Configuration personnalisée

### Étape 4 : Adapter la configuration

1. **Copier le template host** :
```bash
cd /mnt/home/nixos-config
cp -r hosts/laptop hosts/monpc
```

2. **Modifier les variables principales** dans `hosts/monpc/variables.nix` :
```nix
{
  config.var = {
    hostname = "monpc";        # Nom de votre machine
    username = "titi";         # Votre nom d'utilisateur
    keyboardLayout = "fr";     # Disposition clavier
    
    location = "Paris, France";
    timeZone = "Europe/Paris";
    
    git = {
      username = "Votre Nom";
      email = "votre@email.com";
    };
  };
}
```

3. **Mettre à jour flake.nix** :
```nix
# Remplacer la ligne 46
monpc = # Au lieu de nixos
  nixpkgs.lib.nixosSystem {
    # ...
    modules = [
      # Adapter si besoin le module hardware (ligne 62)
      # Pour Framework laptop 12th gen Intel, garder:
      inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
      
      # Sinon, commenter et laisser NixOS détecter
      # ./hosts/monpc/hardware-configuration.nix
      
      ./hosts/monpc/configuration.nix # Mettre à jour le chemin
    ];
  };
```

### Étape 5 : Configuration matérielle

```bash
# Générer la configuration matérielle
nixos-generate-config --root /mnt --show-hardware-config > /mnt/home/nixos-config/hosts/monpc/hardware-configuration.nix
```

### Étape 6 : Première installation

```bash
# Se placer dans le bon répertoire
cd /mnt/home/nixos-config

# Installer avec votre configuration
nixos-install --flake .#monpc

# Définir le mot de passe root
passwd
```

## 🔄 Post-installation

### Étape 7 : Premier démarrage

1. Redémarrer et retirer la clé USB
2. Se connecter en root
3. Finaliser la configuration :

```bash
# Créer votre utilisateur
useradd -m -G wheel -s /bin/bash titi
passwd titi

# Copier la configuration
cp -r /home/nixos-config /home/titi/.config/nixos
chown -R titi:users /home/titi/.config/nixos

# Se connecter avec votre utilisateur
su - titi
cd ~/.config/nixos
```

### Étape 8 : Personnalisation finale

1. **Supprimer les éléments non désirés** :
   - Éditer `hosts/monpc/configuration.nix` et retirer les imports non nécessaires
   - Commenter la ligne des printers si vous n'avez pas la même imprimante

2. **Choisir votre thème** dans `hosts/monpc/configuration.nix` :
```nix
imports = [
  # ...
  ../../themes/nixy    # ou gruvbox, pinky, rose-pine
];
```

3. **Reconstruire le système** :
```bash
nixy rebuild
```

## 📦 Équivalences Ubuntu → NixOS

| Ubuntu | NixOS |
|--------|-------|
| `apt install package` | Ajouter dans `home.nix` puis `nixy rebuild` |
| `apt update && apt upgrade` | `nixy upgrade` |
| `systemctl` | `systemctl` (identique) |
| `.bashrc` | Géré par home-manager |
| `/etc/` configs | Configuration déclarative dans les `.nix` |

## 🔧 Dépannage

### Problèmes courants

1. **Erreur de build** : Vérifier les typos dans les fichiers de configuration
2. **Écran noir au démarrage** : Essayer différents drivers graphiques dans `configuration.nix`
3. **WiFi ne fonctionne pas** : Installer les firmwares : `hardware.enableRedistributableFirmware = true;`

### Commandes utiles

```bash
# Voir les logs du dernier build
nixos-rebuild switch --show-trace

# Rollback si problème
nixos-rebuild switch --rollback

# Nettoyer l'espace disque
nixy gc
```

## 📚 Ressources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nixpkgs Search](https://search.nixos.org/packages)

## 💡 Tips

1. **Apprentissage progressif** : Commencez avec la configuration de base et ajoutez des fonctionnalités petit à petit
2. **Versionnement** : Commitez régulièrement vos changements
3. **Test** : Utilisez `nixos-rebuild test` pour tester sans rendre les changements permanents
4. **Communauté** : Le Discord/Matrix NixOS est très actif pour obtenir de l'aide

Bonne migration vers NixOS ! 🐧❄️