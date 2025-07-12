# Guide Complet des Raccourcis - Nixy (NixOS + Hyprland)

> [!NOTE]
> **SUPER** = Touche Windows par défaut | **SHIFT** = Maj | **ALT** = Alt

## 🚀 Applications Principales

| Raccourci | Application | Description |
|-----------|-------------|-------------|
| `SUPER + T` | **Kitty** | Terminal principal |
| `SUPER + G` | **Google Chrome** | Navigateur web |
| `SUPER + E` | **Nautilus** | Gestionnaire de fichiers graphique |
| `SUPER + Y` | **Yazi** | Gestionnaire de fichiers en CLI |
| `SUPER + K` | **Bitwarden** | Gestionnaire de mots de passe |

## 🪟 Gestion des Fenêtres

| Raccourci | Action |
|-----------|--------|
| `SUPER + Q` | Fermer la fenêtre active |
| `SUPER + RETURN` | Basculer en mode flottant |
| `SUPER + F` | Passer en plein écran |
| `SUPER + L` | Verrouiller l'écran |

### Navigation et Focus
| Raccourci | Action |
|-----------|--------|
| `SUPER + ←/→/↑/↓` | Déplacer le focus (gauche/droite/haut/bas) |
| `SUPER_SHIFT + ↑/↓` | Focus moniteur précédent/suivant |
| `SUPER_SHIFT + ←/→` | Ajouter/retirer du master layout |

### Contrôles Souris
| Raccourci | Action |
|-----------|--------|
| `SUPER + Clic gauche` | Déplacer la fenêtre |
| `SUPER + R` | Redimensionner la fenêtre |

## 🎯 Menus et Outils

| Raccourci | Outil | Description |
|-----------|-------|-------------|
| `SUPER + SPACE` | **Menu Lanceur** | Wofi - Lance des applications |
| `SUPER + X` | **Menu d'Alimentation** | Verrouillage/Déconnexion/Redémarrage/Arrêt |
| `SUPER_SHIFT + SPACE` | **HyprFocus** | Mode concentration (masque la barre) |
| `SUPER_SHIFT + S` | **Recherche Internet** | Recherche avec wofi |
| `SUPER_SHIFT + C` | **Presse-papiers** | Sélecteur de presse-papiers |
| `SUPER_SHIFT + E` | **Émojis** | Sélecteur d'émojis |

## 📸 Captures d'Écran

| Raccourci | Type de Capture |
|-----------|-----------------|
| `PRINT` | Capture de moniteur complet |
| `SUPER + PRINT` | Capture de fenêtre |
| `SUPER_SHIFT + PRINT` | Capture de région |
| `ALT + PRINT` | Capture de région + édition (Swappy) |

## 🎵 Contrôles Système

### Audio
| Raccourci | Action |
|-----------|--------|
| `XF86AudioRaiseVolume` | Augmenter le volume |
| `XF86AudioLowerVolume` | Diminuer le volume |
| `XF86AudioMute` | Couper/rétablir le son |

### Luminosité
| Raccourci | Action |
|-----------|--------|
| `XF86MonBrightnessUp` | Augmenter la luminosité |
| `XF86MonBrightnessDown` | Diminuer la luminosité |

### Filtre Lumière Bleue
| Raccourci | Action |
|-----------|--------|
| `SUPER + F2` | Toggle night-shift |
| `SUPER + F3` | Toggle night-shift |

## 🏢 Espaces de Travail

### Navigation
| Raccourci | Action |
|-----------|--------|
| `SUPER + 1-9` | Aller à l'espace de travail 1-9 |
| `SUPER + F1-F12` | Aller aux espaces de travail 10-21 |
| `SUPER_SHIFT + ←/→` | Espace de travail précédent/suivant |

### Déplacement de Fenêtres
| Raccourci | Action |
|-----------|--------|
| `SUPER_SHIFT + 1-9` | Déplacer la fenêtre vers l'espace 1-9 |
| `SUPER_SHIFT + F1-F12` | Déplacer la fenêtre vers l'espace 10-21 |

## ⚙️ Scripts Personnalisés

Les raccourcis font appel à des scripts personnalisés développés pour Nixy :

### Scripts de Luminosité
- **brightness-up/down** : Contrôle fin de la luminosité avec brightnessctl
- **brightness-set** : Définir une valeur de luminosité spécifique

### Scripts Audio
- **sound-up/down** : Contrôle du volume avec wpctl
- **sound-toggle** : Couper/rétablir le son

### Scripts Système
- **menu** : Lanceur d'applications wofi personnalisé
- **powermenu** : Menu d'alimentation avec options système
- **lock** : Verrouillage d'écran avec hyprlock
- **caffeine** : Désactiver temporairement la mise en veille
- **nixy** : Assistant de gestion système interactif

### Scripts Productivité
- **screenshot** : Gestion avancée des captures d'écran
- **night-shift** : Filtre lumière bleue avec hyprshade
- **hyprfocus** : Mode concentration (masque UI, supprime gaps)
- **notification** : Gestion des notifications
- **clipboard** : Gestionnaire de presse-papiers avec historique

### Scripts Réseau
- **wireguard** : Gestion des connexions VPN

## 🔐 Événements Automatiques

| Événement | Action |
|-----------|--------|
| Fermeture du capot laptop | Verrouillage automatique de l'écran |
| Inactivité prolongée | Activation de hypridle |

## 📝 Configuration et Personnalisation

### Fichiers de Configuration
- **Raccourcis principaux** : `home/system/hyprland/bindings.nix`
- **Scripts** : `home/scripts/*/default.nix`
- **Variables** : `hosts/*/variables.nix`

### Régénérer la Documentation
```bash
./docs/scripts/keybindings_to_markdown.sh
```

### Personnaliser les Raccourcis
1. Modifier `home/system/hyprland/bindings.nix`
2. Rebuild le système : `nixy rebuild`
3. Régénérer la doc : `./docs/scripts/keybindings_to_markdown.sh`

---

*Cette documentation est basée sur la configuration Nixy - un environnement NixOS moderne avec Hyprland, optimisé pour la productivité et l'utilisation au clavier.*