{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.task-master-ai
  ];
}