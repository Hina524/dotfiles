/*
  Terraform

  インフラをコードで管理するIaCツール
*/
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    terraform
  ];
}
