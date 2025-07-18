{
  # https://github.com/anotherhadi/nixy
  description = ''
    Nixy is a NixOS configuration with home-manager, secrets and custom theming all in one place.
    It's a simple way to manage your system configuration and dotfiles.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    nixy-wallpapers = {
      url = "github:anotherhadi/nixy-wallpapers";
      flake = false;
    };
    stylix.url = "github:danth/stylix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    search-nixos-api.url = "github:anotherhadi/search-nixos-api";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, ... }: {
    nixosConfigurations = {
      nixos = # CHANGEME
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = [ 
                # inputs.hyprpanel.overlay # Removed: hyprpanel is now in nixpkgs
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    system = prev.system;
                    config.allowUnfree = true;
                  };
                })
              ];
              _module.args = { inherit inputs; };
            }
            inputs.nixos-hardware.nixosModules.framework-12th-gen-intel # CHANGEME
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/laptop/configuration.nix # CHANGEME
          ];
        };
      titi-framework = 
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs.overlays = [ 
                # inputs.hyprpanel.overlay # Removed: hyprpanel is now in nixpkgs
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    system = prev.system;
                    config.allowUnfree = true;
                  };
                })
              ];
              _module.args = { inherit inputs; };
            }
            inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            ./hosts/titi-framework/configuration.nix
          ];
        };
    };
  };
}
