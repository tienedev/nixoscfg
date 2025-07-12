# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is **Nixy**, a NixOS configuration repository that provides a complete Hyprland-based desktop environment using Nix flakes and home-manager. It's designed to be keyboard-centric, minimalistic, and uses the Hypr ecosystem (Hyprland, Hyprlock, Hyprpanel, Hypridle).

## Build and Development Commands

### System Management
- `sudo nixos-rebuild switch --flake ~/.config/nixos#yourhostname` - Rebuild the system
- `nixy` - Interactive system management wizard (rebuild, upgrade, garbage collection, etc.)
- `nixy rebuild` - Quick system rebuild
- `nixy upgrade` - Rebuild with flake updates
- `nixy update` - Update flake inputs
- `nixy gc` - Run garbage collection
- `nixy ncg` - Garbage collection (delete older than 7 days)
- `nixy cb` - Clean boot menu
- `rg "CHANGEME"` - Find configuration items that need customization

### Development Tools
- `git add .` - Always run this when adding new files (required for flakes)
- `./docs/scripts/create_readme.sh` - Update README from template
- `./docs/scripts/create_scripts_docs.sh` - Regenerate script documentation
- `./docs/scripts/keybindings_to_markdown.sh` - Generate keybindings documentation

## Architecture

### Core Structure

**🏠 home/**: User-level configuration managed by home-manager
- `programs/` - Application configurations (neovim, shell, git, firefox, etc.)
- `scripts/` - Custom bash scripts accessible from PATH
- `system/` - Desktop environment components (hyprland, wofi, etc.)

**🐧 nixos/**: System-level NixOS modules
- Core system services (audio, bluetooth, graphics, fonts, etc.)
- Bootloader, networking, users, and hardware configuration

**🎨 themes/**: Stylix-based theming system
- Multiple theme variants (gruvbox, nixy, pinky, rose-pine)
- Consistent styling across all applications

**💻 hosts/**: Host-specific configurations
- `configuration.nix` - System-level imports and settings
- `home.nix` - User-level imports and packages
- `variables.nix` - Host-specific variables and preferences
- `hardware-configuration.nix` - Hardware-specific settings

### Key Design Patterns

1. **Modular Architecture**: Each component is a separate Nix module that can be imported selectively
2. **Variable-Driven Configuration**: Host-specific settings are centralized in `variables.nix`
3. **Theme Integration**: Stylix provides consistent theming across all applications
4. **Script Management**: Custom scripts are packaged as Nix derivations and added to PATH

## Configuration Variables

The system uses a centralized variable system (`var.*`) for configuration:

```nix
config.var = {
  hostname = "nixos";
  username = "nixos";
  configDirectory = "/home/username/.config/nixos";
  keyboardLayout = "fr";
  theme = {
    rounding = 15;
    gaps-in = 10;
    gaps-out = 20;
    # ... theme settings
  };
};
```

## Custom Scripts

Scripts are located in `home/scripts/` and automatically added to PATH:

- **brightness**: `brightness-up`, `brightness-down`, `brightness-set`
- **caffeine**: `caffeine` (toggle hypridle), `caffeine-status`
- **screenshot**: `screenshot [region|window|monitor] [swappy]`
- **sound**: `sound-up`, `sound-down`, `sound-toggle`
- **system**: `menu`, `powermenu`, `lock`
- **nixy**: System management with interactive UI
- **night-shift**: `night-shift` (toggle blue light filter)
- **hyprfocus**: Window focus management
- **notification**: Notification management utilities
- **wireguard**: VPN connection scripts

## Important Considerations

### Security Notes
- GitHub token in `hosts/laptop/configuration.nix:35` should be removed or secured
- Secrets should use sops-nix or similar secure solutions
- Remove personal information before sharing configurations

### Host Setup Requirements
1. Copy `hosts/laptop/` to create new host configuration
2. Update `hardware-configuration.nix` for target hardware
3. Modify `variables.nix` with host-specific settings
4. Add nixosConfigurations entry in `flake.nix`
5. Address all `# CHANGEME` comments in configuration files

### Theme System
- Themes are applied system-wide via Stylix
- Switch themes by changing the import in `hosts/*/configuration.nix`
- Theme settings are configured in `variables.nix`

## Hyprland Integration

The configuration heavily integrates with Hyprland and its ecosystem:
- Hyprland window manager with custom animations and rules
- Hyprpanel for system bar and widgets
- Hyprlock for screen locking
- Hypridle for idle management
- Hyprpaper for wallpaper management

Keybindings documentation is available in `docs/KEYBINDINGS-HYPRLAND.md`.

## Flake Structure

The repository uses Nix flakes with the following key inputs:
- `nixpkgs` - Main package repository
- `home-manager` - User environment management
- `nixvim` - Neovim configuration framework
- `stylix` - System-wide theming
- `hyprland` and related Hypr ecosystem packages
- `sops-nix` - Secrets management

Host configurations are defined in `flake.nix` under `nixosConfigurations`.