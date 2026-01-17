{ config, pkgs, ... }:
let
  phpWithExtensions = pkgs.php84.withExtensions (
    { enabled, all }:
    enabled
    ++ (with all; [
      pdo
      pdo_pgsql
      pdo_mysql
      pdo_sqlite
      redis
      mbstring
      opcache
      curl
      xml
    ])
  );
in
{
  home.packages = [
    phpWithExtensions
    phpWithExtensions.packages.composer
  ];
}
