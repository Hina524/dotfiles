{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./vscode.nix
    ./php.nix
    ./nodejs.nix
    ./laravel.nix
    ./ngrok.nix
  ];
}
