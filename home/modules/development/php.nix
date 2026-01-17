{ config, pkgs, ... }:
let
  phpWithExtensions = pkgs.php84.withExtensions (
    { enabled, all }:
    enabled
    ++ (with all; [
      pdo_pgsql
      pdo_mysql
      redis
    ])
  );
in
{
  home.packages = [
    phpWithExtensions
    phpWithExtensions.packages.composer
  ];
}
