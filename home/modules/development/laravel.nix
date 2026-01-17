{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    laravel
    sqlite
  ];

  home.shellAliases = {
    artisan = "php artisan";
    sail = "./vendor/bin/sail";
  };
}
