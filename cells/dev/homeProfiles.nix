{
  inputs,
  cell,
}:
{
  git = {
    programs.git = {
      enable = true;

      userName = "Hina524";
      userEmail = "132186412+Hina524@users.noreply.github.com";

      aliases = {
        soft = "reset --soft";
        hard = "reset --hard";
        s1ft = "soft HEAD~1";
        h1rd = "hard HEAD~1";

        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
        tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
        rank = "shortlog -sn --no-merges";
      };

      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "code --wait";
      };
    };
  };

  zsh = {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      dotDir = ".config/zsh";
      shellAliases = {
        ls = "lsd";
      };

    };

    # LSD config
    programs.lsd = {
      enable = true;
    };

    # starship config
    programs.starship = {
      enable = true;
      settings = {
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
  };

  vscode =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vscode
      ];
    };

  /* ruby =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ruby_3_4
      ];
    }; */

  build_tools =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pkg-config
      ];
    };
}
