{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./php.nix
    ./nodejs.nix
    ./laravel.nix
    ./ngrok.nix
    ./gcloud.nix
    ./terraform.nix
  ];
}
