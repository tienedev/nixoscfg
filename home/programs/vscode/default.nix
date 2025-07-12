{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    unstable.claude-code
    unstable.task-master-ai
    unstable.gemini-cli
  ];

  programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
          jdinhlife.gruvbox
          vscode-icons-team.vscode-icons
          jnoortheen.nix-ide
          golang.go
          ziglang.vscode-zig
          waderyan.gitblame
          wix.vscode-import-cost
          editorconfig.editorconfig
          github.copilot
          github.copilot-chat
          ms-vscode-remote.remote-containers
          esbenp.prettier-vscode
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./extensions.nix { inherit pkgs; })
      ;
      profiles.default.userSettings = {
        "chat.editor.fontFamily" = "JetBrainsMono Nerd Font";
        "chat.editor.fontSize" = 17.333333333333332;
        "debug.console.fontFamily" = "JetBrainsMono Nerd Font";
        "debug.console.fontSize" = 17.333333333333332;
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.fontSize" = 17.333333333333332;
        "editor.inlayHints.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.inlineSuggest.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.minimap.sectionHeaderFontSize" = 11.142857142857142;
        "git.autofetch" = true;
        "git.enableSmartCommit" = true;
        "markdown.preview.fontFamily" = "Source Sans Pro";
        "markdown.preview.fontSize" = 17.333333333333332;
        "scm.inputFontFamily" = "JetBrainsMono Nerd Font";
        "scm.inputFontSize" = 16.095238095238095;
        "screencastMode.fontSize" = 69.33333333333333;
        "terminal.integrated.fontSize" = 17.333333333333332;
        "workbench.colorTheme" = "Stylix";
      };
  };
}
