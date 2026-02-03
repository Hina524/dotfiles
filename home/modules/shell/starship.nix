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
