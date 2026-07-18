/*
  Git 設定

  Gitのユーザー情報・エイリアス・エディタ・運用設定を管理する：
  - ユーザー名とメールはshared/config.nixから取得
  - エイリアス: undo（直前コミット取り消し）, cleanup（マージ済みブランチを削除）
  - 運用設定:
    - push.autoSetupRemote: 新規ブランチの初回pushで -u origin 不要
    - fetch.prune: fetch時にリモートで消えたブランチを自動削除
    - branch.sort: git branch を最近使った順に表示
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
        undo = "reset --soft HEAD~1";
        # main にマージ済みのローカルブランチを削除する（-d なので未マージは削除されず安全）。
        # main と現在ブランチは除外する。merge commit 運用が前提。
        cleanup = "!git branch --merged main | grep -vE '^[+*]|\\bmain\\b' | while read -r b; do git branch -d \"$b\"; done";
      };

      push.autoSetupRemote = true;
      fetch.prune = true;
      branch.sort = "-committerdate";

      init.defaultBranch = "main";
      core.editor = "code --wait";
    };

    # 全プロジェクト共通の無視設定（~/.config/git/ignore に出力される）
    ignores = [
      "**/.claude/settings.local.json"
      ".agent/handoff.md"
    ];
  };
}
