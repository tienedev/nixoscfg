{ pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.phpstorm
    insomnia
    postman
  ];

  # Configuration pour les applications JetBrains
  home.file.".local/share/applications/jetbrains-phpstorm.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=PhpStorm
    Icon=phpstorm
    Exec=env _JAVA_OPTIONS='-Dawt.toolkit.name=WLToolkit -Djdk.gtk.version=3 -Dsun.java2d.xrender=false -Dsun.java2d.opengl=false' phpstorm %f
    Comment=PHP IDE by JetBrains
    Categories=Development;IDE;
    Terminal=false
    StartupWMClass=jetbrains-phpstorm
  '';

  # Variables d'environnement spécifiques pour JetBrains
  home.sessionVariables = {
    # Options Java pour Wayland
    _JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit -Djdk.gtk.version=3 -Dsun.java2d.xrender=false -Dsun.java2d.opengl=false";
    # Variables pour Qt (utilisé par certaines parties de l'interface)
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCREEN_SCALE_FACTORS = "1";
    # Forcer l'utilisation de Wayland
    GDK_BACKEND = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}
