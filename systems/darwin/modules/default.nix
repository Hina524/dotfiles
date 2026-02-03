{ config, pkgs, ... }:
{
  imports = [
    ./homebrew.nix
    ./macos-defaults.nix
    ./nix.nix
  ];
}
