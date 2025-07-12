{ pkgs, inputs,... }:
{
  stylix = {
    # Activer stylix
    enable = true;

    # Thème Gruvbox
    base16Scheme = {
      base00 = "282828"; # fond
      base01 = "3c3836"; # fond clair
      base02 = "504945"; # fond sélection
      base03 = "665c54"; # commentaires
      base04 = "bdae93"; # gris foncé
      base05 = "d5c4a1"; # premier plan
      base06 = "ebdbb2"; # premier plan clair
      base07 = "fbf1c7"; # premier plan plus clair
      base08 = "fb4934"; # rouge
      base09 = "fe8019"; # orange
      base0A = "fabd2f"; # jaune
      base0B = "b8bb26"; # vert
      base0C = "8ec07c"; # aqua/cyan
      base0D = "83a598"; # bleu
      base0E = "d3869b"; # violet
      base0F = "d65d0e"; # marron
    };

    cursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 24;
    };

    # Configuration des polices
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 13;
        desktop = 13;
        popups = 13;
        terminal = 13;
      };
    };
    # Autres configurations du thème
    opacity.terminal = 0.95;
    opacity.applications = 1.0;

    # Polarity (dark/light)
    polarity = "dark"; # ou "light" pour le thème clair

    image = inputs.nixy-wallpapers + "/wallpapers/city.png";
  };
}