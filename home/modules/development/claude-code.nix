/*
  Claude Code 設定モジュール

  機能:
    Claude Code（公式 CLI）のステータスラインスクリプトを配置する。
    ターミナル下部にモデル名・コンテキスト残量%・Git ブランチ・コストを常時表示する。

  設定:
    home.file で ~/.claude/statusline.sh へ宣言的にデプロイする（実行可能属性付き）。
    settings.json は nix 管理しない（Claude 本体が /config 等で書き込むため）。
    有効化には ~/.claude/settings.json に以下を手動で追記する：
      "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }

  使用方法:
    rebuild 後、新しいセッションでステータスラインが表示される。
    echo '<JSON>' | ~/.claude/statusline.sh で単体テスト可能。
*/
{ ... }:
{
  home.file.".claude/statusline.sh" = {
    source = ./claude-statusline.sh;
    executable = true;
  };
}
