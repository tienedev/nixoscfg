# { pkgs, lib, ... }: 
# {
#   # Ghostty - Terminal alternatif moderne
#   # Avantages par rapport à Kitty :
#   # - Performance supérieure (écrit en Zig)
#   # - Meilleure gestion des ligatures de code
#   # - Rendu de texte plus fluide
#   # - Support GPU natif optimisé
#   # - Démarrage plus rapide
#   programs.ghostty = {
#     enable = true;
#     enableZshIntegration = true;
#     settings = {
#       theme = "GruvboxLightHard"; #command => ghostty +list-themes
#       copy-on-select = false;
#       shell-integration = "zsh";
#       auto-update = "off";
#       keybind = [
#         "performable:ctrl+c=copy_to_clipboard"
#         "ctrl+v=paste_from_clipboard"
#       ];
#     };
#   };
# }

# Configuration Ghostty désactivée
{ pkgs, lib, ... }: { }