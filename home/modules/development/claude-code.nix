/*
  Claude Code 設定モジュール

  機能:
    Claude Code のステータスライン・skills を宣言的にデプロイする。

    ステータスライン:
      ターミナル下部にモデル名・コンテキスト使用量・Git ブランチ・コスト・レート制限を2段表示する。

    Skills:
      - handoff: /handoff で .agent/handoff.md に作業状態を構造化して書き出す
        （コンパクションやセッション再開に備えた手動運用の引き継ぎドキュメント）
      - japanese-tech-writing: 日本語の記事・ノート・技術文書を AI っぽくない自然な文章で書くための規範

    Hooks:
      - safety-gate: 機密ファイル（SSH秘密鍵・credentials.json 等）へのアクセスを
        ツール実行前にブロックする PreToolUse hook（auto モードの安全網）

  設定:
    home.file で各ファイルを ~/.claude/ 配下に宣言的にデプロイする。
    settings.json は nix 管理しない（Claude 本体が /config 等で書き込むため）。
    ステータスライン有効化には ~/.claude/settings.json に以下を手動で追記する:
      "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" }
    skill は ~/.claude/skills/ に置くだけで自動認識される（設定追記不要）。
    hook の有効化には ~/.claude/settings.json に以下を手動で追記する:
      "hooks": {
        "PreToolUse": [
          { "matcher": "Read|Write|Edit|Bash|Grep",
            "hooks": [{ "type": "command", "command": "~/.claude/hooks/safety-gate.sh" }] }
        ]
      }

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

  home.file.".claude/skills/japanese-tech-writing/SKILL.md" = {
    source = ./claude-skills/japanese-tech-writing/SKILL.md;
  };

  # Hooks
  home.file.".claude/hooks/safety-gate.sh" = {
    source = ./claude-hooks/safety-gate.sh;
    executable = true;
  };
}
