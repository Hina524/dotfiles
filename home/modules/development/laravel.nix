/*
  Laravel 開発環境

  LaravelとSQLiteを提供し、開発用エイリアスを設定する：
  - artisan: php artisanのショートカット
  - sail: Laravel Sailのショートカット
*/
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
