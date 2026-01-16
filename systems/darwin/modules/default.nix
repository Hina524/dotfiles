{ config, pkgs, ... }:
{
  imports = [
    ./homebrew.nix
    ./nix.nix
  ];
}
