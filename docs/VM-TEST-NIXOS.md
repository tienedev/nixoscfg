# Test de NixOS avec ta configuration dans VirtualBox

Ce guide te permet de tester ta configuration NixOS personnalisée en toute sécurité dans une VM.

## 📦 Étape 1 : Installation de VirtualBox

```bash
# Installer VirtualBox et l'extension pack
sudo apt update
sudo apt install virtualbox virtualbox-qt virtualbox-dkms virtualbox-ext-pack

# Ajouter ton utilisateur au groupe vboxusers
sudo usermod -aG vboxusers $USER

# Redémarrer la session ou faire :
newgrp vboxusers
```

## 💿 Étape 2 : Télécharger l'ISO NixOS

```bash
cd ~/Downloads
# ISO minimale (plus rapide, 800MB)
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# OU ISO graphique avec GNOME (2.1GB) - plus facile pour débuter
wget https://channels.nixos.org/nixos-unstable/latest-nixos-gnome-x86_64-linux.iso
```

## 🖥️ Étape 3 : Créer la VM

### Configuration VirtualBox :

1. **Ouvrir VirtualBox** → "Nouvelle"

2. **Paramètres de base** :
   - Nom : `NixOS-Test-Titi`
   - Type : Linux
   - Version : Other Linux (64-bit)

3. **Ressources** :
   - RAM : 4096 MB (minimum, 8192 MB recommandé)
   - CPU : 2-4 cores
   - Disque : 30 GB (dynamiquement alloué)

4. **Configuration avancée** (clic droit → Configuration) :
   - **Système** :
     - ✅ Activer EFI
     - ✅ Activer PAE/NX
     - Ordre de boot : Disque optique, puis Disque dur
   - **Affichage** :
     - Mémoire vidéo : 128 MB
     - ✅ Activer l'accélération 3D
   - **Stockage** :
     - Ajouter l'ISO dans le lecteur optique
   - **Réseau** :
     - Mode : NAT (ou Bridge pour accès complet)

## 🚀 Étape 4 : Installation dans la VM

### Boot et partitionnement

1. **Démarrer la VM** et attendre le prompt

2. **Partitionner le disque** :
```bash
# Pour VM, on simplifie avec une seule partition
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary 512MB 100%

# Formater
sudo mkfs.fat -F32 -n BOOT /dev/sda1
sudo mkfs.ext4 -L nixos /dev/sda2

# Monter
sudo mount /dev/sda2 /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/sda1 /mnt/boot
```

### Installation avec ta config

3. **Récupérer ta configuration** :
```bash
# Installer git
nix-env -iA nixos.git

# Deux options :

# Option A : Depuis GitHub (si tu as pushé)
cd /mnt
sudo git clone https://github.com/TON_USERNAME/nixosframe.git

# Option B : Depuis le host (partage VirtualBox)
# D'abord sur l'hôte Ubuntu :
# - Dans VirtualBox : Périphériques → Dossiers partagés
# - Ajouter /home/titi/actualtysoft/POC/nixosframe
# Puis dans la VM :
sudo mkdir /mnt/shared
sudo mount -t vboxsf nixosframe /mnt/shared
sudo cp -r /mnt/shared /mnt/nixosframe
```

4. **Générer hardware-configuration** :
```bash
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/nixosframe/hosts/titi-framework/
```

5. **Installer NixOS** :
```bash
cd /mnt/nixosframe
sudo nixos-install --flake .#titi-framework --no-root-passwd
```

6. **Définir les mots de passe** :
```bash
# Root
sudo nixos-enter --root /mnt -c "passwd"

# Ton utilisateur
sudo nixos-enter --root /mnt -c "passwd titi"
```

7. **Finaliser** :
```bash
# Copier la config dans le home
sudo nixos-enter --root /mnt -c "cp -r /nixosframe /home/titi/.config/nixos && chown -R titi:users /home/titi/.config/nixos"

# Redémarrer
sudo reboot
```

## 🎮 Étape 5 : Découverte de NixOS

### Premier boot

1. **Login** avec utilisateur `titi`

2. **Ouvrir un terminal** (Super+T dans Hyprland)

3. **Commandes de base** :
```bash
# Voir ta config
cd ~/.config/nixos
ls -la

# Mettre à jour le système
nixy rebuild

# Installer un package temporairement
nix-shell -p cowsay
cowsay "Bienvenue dans NixOS!"

# Voir les packages installés
nix-env -q

# Ouvrir le menu d'applications
menu  # ou Super+D
```

### Explorer Hyprland

- `Super + Enter` : Terminal
- `Super + D` : Menu applications (wofi)
- `Super + Q` : Fermer fenêtre
- `Super + 1/2/3...` : Changer workspace
- `Super + Shift + S` : Screenshot

### Tester des modifications

1. **Éditer la config** :
```bash
cd ~/.config/nixos
nvim hosts/titi-framework/home.nix
```

2. **Ajouter un package** (exemple) :
```nix
home.packages = with pkgs; [
  # Ajouter :
  neofetch
  htop
  # ...
];
```

3. **Appliquer** :
```bash
nixy rebuild
```

## 💡 Tips pour la VM

### Performances
- Si c'est lent, augmente la RAM
- Active la virtualisation dans le BIOS (VT-x/AMD-V)
- Utilise l'ISO minimale pour l'installation

### Guest Additions (optionnel)
```bash
# Pour un meilleur support (résolution, copier-coller)
# Ajouter dans configuration.nix :
virtualisation.virtualbox.guest.enable = true;
```

### Snapshots
- **Avant chaque grosse modification** : Machine → Prendre un instantané
- Permet de revenir en arrière facilement

## 🔄 Sync avec machine principale

Pour garder la config à jour :
```bash
# Dans la VM
cd ~/.config/nixos
git pull

# Ou depuis l'hôte, re-monter le dossier partagé
```

## ❓ Problèmes courants

1. **Écran noir** : Désactiver l'accélération 3D
2. **Résolution fixe** : Installer guest additions
3. **Pas de réseau** : Vérifier mode NAT/Bridge
4. **Erreur EFI** : S'assurer que EFI est activé dans la VM

---

🎉 **Amuse-toi à explorer !** NixOS est différent mais très puissant une fois qu'on comprend sa philosophie.