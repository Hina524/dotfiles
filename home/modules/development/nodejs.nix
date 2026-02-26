# Node.js 実行環境
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs
  ];
}
