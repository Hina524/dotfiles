/*
  Claude Code 設定モジュール

  機能:
    Claude Code のステータスライン・skills を宣言的にデプロイする。

    ステータスライン:
      ターミナル下部にモデル名・コンテキスト使用量・Git ブランチ・コスト・レート制限を2段表示する。

    Skills:
      - handoff: /handoff で .agent/handoff.md に作業状態を構造化して書き出す
        （コンパクションやセッション再開に備えた手動運用の引き継ぎドキュメント）

  設定:
    home.file で各ファイルを ~/.claude/ 配下に宣言的にデプロイする。
    settings.json は nix 管理しない（Claude 本体が /config 等で書き込むため）。
    ステータスライン有効化には ~/.claude/settings.json に以下を手動で追記する:
      "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }
    skill は ~/.claude/skills/ に置くだけで自動認識される（設定追記不要）。

  使用方法:
    rebuild 後、コンテキストが圧迫されてきたら /handoff を実行して
    .agent/handoff.md を作成・更新する。次セッションでそれを読めば作業を継続できる。
*/
{ ... }:
{
  # ステータスライン
  home.file.".claude/statusline.sh" = {
    source = ./claude-statusline.sh;
    executable = true;
  };

  # Skills
  home.file.".claude/skills/handoff/SKILL.md" = {
    source = ./claude-skills/handoff/SKILL.md;
  };
}
