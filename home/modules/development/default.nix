{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./github.nix
    ./php.nix
    ./nodejs.nix
    ./laravel.nix
    ./ngrok.nix
    ./gcloud.nix
    ./terraform.nix
  ];
}
