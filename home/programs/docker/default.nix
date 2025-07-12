{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ 
    docker
    lazydocker
    ctop
  ];

  programs.zsh.shellAliases = {
    d = "docker";
    dc = "docker compose";
    dps = "docker ps";
    di = "docker images";
    dex = "docker exec -it";
    dl = "lazydocker";
  };
}