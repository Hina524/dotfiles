/*
  Git 設定

  Gitのユーザー情報・エイリアス・エディタを管理する：
  - ユーザー名とメールはshared/config.nixから取得
  - ログ表示用エイリアス（lg, plog, tlog, rank）
  - リセット用エイリアス（soft, hard, s1ft, h1rd）
  - デフォルトブランチ: main、エディタ: VSCode
*/
{
  config,
  pkgs,
  sharedConfig,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = sharedConfig.git.name;
        email = sharedConfig.git.email;
      };

      alias = {
        soft = "reset --soft";
        hard = "reset --hard";
        s1ft = "soft HEAD~1";
        h1rd = "hard HEAD~1";

        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
        tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";
        rank = "shortlog -sn --no-merges";
      };

      init.defaultBranch = "main";
      core.editor = "code --wait";
    };
  };
}
