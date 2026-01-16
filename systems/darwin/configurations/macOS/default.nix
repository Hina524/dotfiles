{ config, pkgs, inputs, ... }:
{
  imports = [
    ../../modules
  ];

  system.stateVersion = 5;
  system.primaryUser = "hina";

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.hina = {
    createHome = true;
    home = "/Users/hina";
    shell = pkgs.zsh;
  };
}
