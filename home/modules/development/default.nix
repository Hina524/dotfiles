{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./vscode.nix
  ];
}
