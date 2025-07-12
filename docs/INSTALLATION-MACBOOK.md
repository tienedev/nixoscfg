# Installation de NixOS sur MacBook Air 2013

Ce guide explique comment installer NixOS avec la configuration Nixy sur un MacBook Air 2013.

## ⚠️ Avertissements importants

1. **WiFi** : Le WiFi Broadcom peut nécessiter des drivers propriétaires
2. **Webcam** : La FaceTime HD Camera peut ne pas fonctionner
3. **Thunderbolt** : Support limité sous Linux
4. **Batterie** : L'autonomie sera réduite par rapport à macOS

## 📋 Préparation

### 1. Depuis macOS (si encore installé)

```bash
# Vérifier le modèle exact
system_profiler SPHardwareDataType | grep "Model Identifier"

# Sauvegarder la table de partition EFI
sudo dd if=/dev/disk0s1 of=~/Desktop/efi-backup.img bs=512

# Réduire la partition macOS si dual-boot souhaité
# Utiliser Disk Utility ou :
diskutil apfs resizeContainer disk0s2 100GB
```

### 2. Créer la clé USB d'installation

```bash
# Télécharger l'ISO NixOS
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# Créer la clé (remplacer /dev/diskX par votre clé USB)
sudo dd if=latest-nixos-minimal-x86_64-linux.iso of=/dev/diskX bs=4M
```

### 3. Configurer le démarrage

1. Redémarrer en maintenant `Option (⌥)`
2. Sélectionner la clé USB "EFI Boot"
3. Si problème, désactiver SIP :
   - Redémarrer en Recovery Mode (⌘+R)
   - Terminal → `csrutil disable`

## 🔧 Installation

### Étape 1 : Vérifier le matériel

```bash
# Vérifier la carte WiFi
lspci | grep Network

# Si Broadcom BCM4360, charger le module
modprobe wl

# Tester la connexion
ip link
nmcli device wifi list
```

### Étape 2 : Partitionnement

**Option A : Installation complète (efface macOS)**

```bash
# ATTENTION : Efface tout le disque !
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary 512MB 100%

mkfs.fat -F32 -n BOOT /dev/sda1
mkfs.ext4 -L nixos /dev/sda2

mount /dev/sda2 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
```

**Option B : Dual-boot avec macOS**

```bash
# Utiliser l'EFI existante
mount /dev/sda4 /mnt  # Partition Linux créée précédemment
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot  # EFI partagée avec macOS
```

### Étape 3 : Configuration WiFi

Si le WiFi ne fonctionne pas automatiquement :

```bash
# Option 1 : Utiliser un adaptateur USB ou Ethernet
# Option 2 : Partage de connexion iPhone/Android via USB

# Si Broadcom fonctionne :
nmcli device wifi connect "SSID" password "password"
```

### Étape 4 : Installation

```bash
# Installer git
nix-env -iA nixos.git

# Cloner la configuration
cd /mnt/home
git clone https://github.com/yourusername/nixosframe.git nixos-config
cd nixos-config

# Générer la configuration hardware
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hosts/titi-macbook/

# Installer
nixos-install --flake .#titi-macbook
```

## 🎯 Configuration spécifique MacBook

La configuration `titi-macbook` inclut :

### Support matériel
- **Clavier Apple** : Touches Fn inversées, raccourcis media
- **Trackpad** : Multi-touch, gestures naturelles
- **Rétroéclairage** : Écran et clavier
- **Batterie** : Optimisations TLP
- **Son** : Configuration PipeWire optimisée
- **Graphiques** : Intel HD Graphics 5000

### Raccourcis clavier
- `Fn` → `Control` (inversé pour compatibilité)
- `F1/F2` : Luminosité écran
- `F5/F6` : Rétroéclairage clavier
- `F7-F9` : Contrôles media
- `F10-F12` : Volume

### Gestion énergie
- CPU governor adaptatif
- Mise en veille optimisée
- WiFi power saving

## 🔧 Post-installation

### 1. Optimisations supplémentaires

```bash
# Calibrer la batterie
sudo powertop --calibrate

# Vérifier les températures
sensors-detect
watch sensors

# Optimiser le SSD
sudo fstrim -v /
```

### 2. Résolution de problèmes

**WiFi ne fonctionne pas :**
```bash
# Vérifier le module
lsmod | grep wl

# Recharger le module
sudo modprobe -r wl && sudo modprobe wl

# Alternative : installer broadcom-wl depuis AUR
```

**Trackpad non reconnu :**
```bash
# Vérifier la détection
xinput list

# Forcer le rechargement
sudo modprobe -r bcm5974 && sudo modprobe bcm5974
```

**Son crachotant :**
```bash
# Ajuster la latence dans configuration.nix
services.pipewire.config.pipewire = {
  "context.properties" = {
    "default.clock.quantum" = 2048;
  };
};
```

## 📝 Dual-boot avec macOS

Si vous gardez macOS :

1. **Installer rEFInd** (depuis macOS) :
```bash
# Télécharger rEFInd
curl -L https://sourceforge.net/projects/refind/files/latest/download -o refind.zip
unzip refind.zip
cd refind-*/
sudo ./refind-install
```

2. **Configurer le timeout** dans `/boot/efi/EFI/refind/refind.conf` :
```
timeout 20
use_graphics_for linux
```

## 🚀 Commandes utiles

```bash
# Reconstruire avec la config MacBook
sudo nixos-rebuild switch --flake ~/.config/nixos#titi-macbook

# Gérer la luminosité
brightnessctl set 50%
light -A 10  # Augmenter de 10%

# Vérifier la batterie
acpi -b
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# WiFi
nmcli device wifi list
nmcli device wifi connect "SSID" password "pass"
```

## 📚 Ressources

- [NixOS on Apple Hardware](https://nixos.wiki/wiki/Apple_Hardware)
- [Arch Wiki MacBook Air 2013](https://wiki.archlinux.org/title/MacBookAir)
- [nixos-hardware repo](https://github.com/NixOS/nixos-hardware)

Bonne installation ! 🍎❄️