/*
  GitHub CLI

  ghコマンドを提供する（issue作成、PR操作等）
  設定ファイルはnixで管理せず、既存の~/.config/gh/を使用する
*/
{ config, pkgs, ... }:
{
  home.packages = [ pkgs.gh ];
}
