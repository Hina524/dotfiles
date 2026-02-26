/*
  ngrok トンネリングツール

  ローカルサーバーを外部公開するためのツール
*/
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ngrok
  ];
}
