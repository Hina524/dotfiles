/*
  Google Cloud SDK

  GCPのリソース管理用CLIツール（gcloud, gsutil等）
*/
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    google-cloud-sdk
  ];
}
