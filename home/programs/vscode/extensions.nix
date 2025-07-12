{ pkgs, ... }: [
  {
    name = "vscode-jetbrains-keybindings";
    publisher = "isudox";
    version = "0.1.9";
    # cspell:disable-next-line
    sha256 = "0fb0m1r17lxk132m94gklxkr5y1pmnxgiafciaailsbqv9w3ms33";
  }
  {
    name = "vscode-conventional-commits";
    publisher = "vivaxy";
    version = "1.26.0";
    # cspell:disable-next-line
    sha256 = "1n414wwd6my4xjmh55b6l0s8bqadnq35ya1isxvdi6yabapbwg9f";
  }
  {
    name = "claude-code";
    publisher = "anthropic";
    version = "1.0.31";
    hash = "sha256-3brSSb6ERY0In5QRmv5F0FKPm7Ka/0wyiudLNRSKGBg=";
  }
]