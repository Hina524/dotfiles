/*
  Nix 本体の設定

  Nixのビルド・セキュリティ・ストレージ最適化を管理する：
  - サンドボックス有効化、全コアを使った並列ビルド
  - flakesとnix-commandの有効化
  - 自動GC（毎週日曜、30日以上古いものを削除）
  - ストアの自動最適化
*/
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
