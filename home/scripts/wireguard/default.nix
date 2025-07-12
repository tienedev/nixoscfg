# - ## WireGuard
#- 
#- Scripts pour se connecter et se déconnecter au serveur WireGuard
#-
#- - `wg-connect` - Se connecter au serveur WireGuard.
#- - `wg-disconnect` - Se déconnecter du serveur WireGuard.
{ pkgs, ... }:

let
  wg-connect = pkgs.writeShellScriptBin "wg-connect"
    # bash
    ''
      # Script pour se connecter au serveur WireGuard
      
      CONFIG_FILE="/home/noureddine/.config/nixos/WGHOME-NixOs.conf"
      INTERFACE_NAME="wghome"
      
      # Vérifier si l'utilisateur est root
      if [ "''$(id -u)" -ne 0 ]; then
          echo "Ce script doit être exécuté en tant que root (avec sudo)."
          exit 1
      fi
      
      # Vérifier si le fichier de configuration existe
      if [ ! -f "''${CONFIG_FILE}" ]; then
          echo "Erreur: Le fichier de configuration WireGuard n'existe pas: ''${CONFIG_FILE}"
          exit 1
      fi
      
      # Vérifier si l'interface est déjà active
      if ip link show "''${INTERFACE_NAME}" &>/dev/null; then
          echo "L'interface WireGuard ''${INTERFACE_NAME} est déjà active."
          echo "État actuel:"
          wg show "''${INTERFACE_NAME}"
          exit 0
      fi
      
      # Créer et activer l'interface WireGuard
      echo "Activation de l'interface WireGuard ''${INTERFACE_NAME}..."
      ip link add dev "''${INTERFACE_NAME}" type wireguard
      wg setconf "''${INTERFACE_NAME}" "''${CONFIG_FILE}"
      ip link set "''${INTERFACE_NAME}" up
      
      # Configurer les routes à partir du fichier de configuration
      ADDRESS=''$(grep -oP 'Address = \K[^,]+' "''${CONFIG_FILE}" | cut -d'/' -f1)
      CIDR=''$(grep -oP 'Address = \K[^,]+' "''${CONFIG_FILE}" | cut -d'/' -f2)
      ALLOWED_IPS=''$(grep -oP 'AllowedIPs = \K.*' "''${CONFIG_FILE}")
      
      # Configurer l'adresse IP
      ip addr add "''${ADDRESS}/''${CIDR}" dev "''${INTERFACE_NAME}"
      
      # Ajouter les routes pour AllowedIPs
      IFS=',' read -ra IPS <<< "''${ALLOWED_IPS}"
      for ip in "''${IPS[@]}"; do
          # Ignorer les routes pour l'adresse locale
          if [[ "''${ip}" != "''${ADDRESS}/''${CIDR}" ]]; then
              ip route add "''${ip}" dev "''${INTERFACE_NAME}"
          fi
      done
      
      # Vérifier si 0.0.0.0/0 est dans AllowedIPs (tunnel tout le trafic)
      if [[ "''${ALLOWED_IPS}" == *"0.0.0.0/0"* ]]; then
          # Sauvegarder la route par défaut actuelle
          DEFAULT_ROUTE=''$(ip route show default | head -n1)
          echo "''${DEFAULT_ROUTE}" > "/tmp/wireguard_default_route_''${INTERFACE_NAME}"
          
          # Configurer la route par défaut via WireGuard
          ip route replace default dev "''${INTERFACE_NAME}"
          echo "Tout le trafic est maintenant acheminé via WireGuard."
      fi
      
      echo "Connexion établie avec succès à ''${INTERFACE_NAME}."
      echo "État de la connexion:"
      wg show "''${INTERFACE_NAME}"
    '';

  wg-disconnect = pkgs.writeShellScriptBin "wg-disconnect"
    # bash
    ''
      # Script pour se déconnecter du serveur WireGuard
      
      INTERFACE_NAME="wghome"
      
      # Vérifier si l'utilisateur est root
      if [ "''$(id -u)" -ne 0 ]; then
          echo "Ce script doit être exécuté en tant que root (avec sudo)."
          exit 1
      fi
      
      # Vérifier si l'interface existe
      if ! ip link show "''${INTERFACE_NAME}" &>/dev/null; then
          echo "L'interface WireGuard ''${INTERFACE_NAME} n'est pas active."
          exit 0
      fi
      
      # Vérifier si nous avons sauvegardé une route par défaut
      DEFAULT_ROUTE_FILE="/tmp/wireguard_default_route_''${INTERFACE_NAME}"
      if [ -f "''${DEFAULT_ROUTE_FILE}" ]; then
          # Restaurer la route par défaut originale
          DEFAULT_ROUTE=''$(cat "''${DEFAULT_ROUTE_FILE}")
          echo "Restauration de la route par défaut originale..."
          ip route replace ''${DEFAULT_ROUTE}
          rm -f "''${DEFAULT_ROUTE_FILE}"
      fi
      
      # Supprimer l'interface WireGuard
      echo "Désactivation de l'interface WireGuard ''${INTERFACE_NAME}..."
      ip link delete dev "''${INTERFACE_NAME}"
      
      echo "Déconnexion réussie de ''${INTERFACE_NAME}."
    '';

in { home.packages = [ wg-connect wg-disconnect ]; }
