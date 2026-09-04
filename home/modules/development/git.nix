/*
  Git 設定

  Gitのユーザー情報・エイリアス・エディタ・運用設定を管理する：
  - ユーザー名とメールはshared/config.nixから取得
  - エイリアス: undo（直前コミット取り消し）, cleanup（マージ済みブランチを削除）
    cleanup の実体は git-cleanup-merged.sh。merge commit 運用と squash 運用の両方に対応し、
    `git cleanup --dry-run` で削除せず対象だけ確認できる
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
        # マージ済みのローカルブランチを削除する。main と現在ブランチは除外する。
        # merge commit 運用と squash 運用の両方に対応する（判定の詳細はスクリプト冒頭を参照）。
        # 従来は `git branch --merged` のみで、squash されたブランチを検出できなかった。
        cleanup = "!$HOME/.config/git/cleanup-merged.sh";
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

  # cleanup エイリアスの実体
  home.file.".config/git/cleanup-merged.sh" = {
    source = ./git-cleanup-merged.sh;
    executable = true;
  };
}
