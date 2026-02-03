{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    dotDir = "${config.xdg.configHome}/zsh";
    shellAliases = {
    };
  };

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

  programs.lsd = {
    enable = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
    enableBashIntegration = true;
  };
}
