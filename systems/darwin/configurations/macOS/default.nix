{
  config,
  pkgs,
  inputs,
  sharedConfig,
  ...
}:
{
  imports = [
    ../../modules
  ];

  system.stateVersion = 5;
  system.primaryUser = sharedConfig.username;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${sharedConfig.username} = {
    createHome = true;
    home = sharedConfig.homeDirectory;
    shell = pkgs.zsh;
  };
}
