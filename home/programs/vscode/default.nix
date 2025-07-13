{ pkgs, config, ... }:
{
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
          "database-client.autoSync" = true;
          "workbench.iconTheme" = "vscode-icons-mac";
          "github.copilot.chat.edits.temporalContext.enabled" = true;
          "github.copilot.chat.languageContext.typescript.enabled" = true;
          "github.copilot.chat.search.semanticTextResults" = true;
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "github.copilot.chat.editor.temporalContext.enabled" = true;
          "github.copilot.chat.completionContext.typescript.mode" = "on";
          "github.copilot.chat.edits.codesearch.enabled" = true;
          "github.copilot.chat.localeOverride" = "fr";
          "editor.formatOnSave" = true;
          "terminal.integrated.allowedLinkSchemes" = [
            "file"
            "http"
            "https"
            "mailto"
            "vscode"
            "vscode-insiders"
          ];
        };
  };
}
