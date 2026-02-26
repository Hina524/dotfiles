/*
  Starship プロンプト設定

  シェルプロンプトのカスタマイズ：
  - gcloud表示を無効化
  - コマンドの終了ステータスを表示
  - 日本時間（UTC+9）で日時を表示
*/
{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      gcloud = {
        disabled = true;
      };
      status = {
        disabled = false;
      };
      time = {
        disabled = false;
        utc_time_offset = "+9";
        time_format = "%Y-%m-%d %H:%M";
      };
    };
  };
}
