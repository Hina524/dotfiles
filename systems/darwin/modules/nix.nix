{ config, pkgs, ... }:
{
  nix.settings.sandbox = true;
  nix.settings.trusted-users = [ "@admin" ];
  nix.settings.allowed-users = [ "@admin" ];
  nix.settings.max-jobs = "auto";
  nix.settings.cores = 0; # 全コア使用
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Storage optimization
  # https://wiki.nixos.org/wiki/Storage_optimization
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
}
