{ config, pkgs, ... }:
{
  imports = [
    ../../modules/shell
    ../../modules/development
  ];

  home.stateVersion = "24.11";
  xdg.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.fira-code

    # Nix tools
    nil
    nixd
    nixfmt

    # Applications
    discord
    slack
    obsidian
    google-chrome

    # Development
    jdk21
    gemini-cli
    pkg-config
    xcodes
    claude-code
  ];
}
