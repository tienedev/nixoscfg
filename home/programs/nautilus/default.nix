{ pkgs, ... }: {
  home.packages = with pkgs; [
    nautilus
    sushi # thumbnails in nautilus
  ];
}
