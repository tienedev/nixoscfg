{ pkgs, lib, ... }: 
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "GruvboxLightHard"; #command => ghostty +list-themes
      copy-on-select = false;
      shell-integration = "zsh";
      auto-update = "off";
      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
      ];
    };
  };
}