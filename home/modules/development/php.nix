/*
  PHP 開発環境

  PHP 8.4と追加拡張・Composerを提供する：
  - pdo_pgsql, pdo_mysql: データベース接続
  - redis: キャッシュ/セッション管理
*/
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
