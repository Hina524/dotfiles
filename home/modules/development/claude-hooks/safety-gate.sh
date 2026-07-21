#!/usr/bin/env bash
#
# safety-gate hook（PreToolUse）
#
# 機能:
#   Claude Code がツールを実行する直前に呼ばれ、機密ファイルへのアクセスを
#   検出したらブロックする（exit 2）。auto モード運用の安全網。
#
# 対象ツールと判定:
#   - Read / Write / Edit / NotebookEdit / Grep: file_path / path を検査し、
#     機密パターンに一致したらブロック（公開鍵 .pub は許可）
#   - Bash: command を検査するが、単に機密名を文字列として含むだけ
#     （コミットメッセージ・PR 本文・ドキュメント等）は許可し、
#     cat/cp/scp 等の読み出し・持ち出し系コマンドが機密ファイルを
#     対象にした場合のみブロックする（誤爆防止）
#
#   .env / .envrc は direnv 運用のため意図的に許可（ブロックしない）。
#
# 設定:
#   home.file で ~/.claude/hooks/safety-gate.sh にデプロイし、
#   ~/.claude/settings.json の hooks.PreToolUse に手動で登録する。
#
# 使用方法（テスト）:
#   echo '{"tool_name":"Read","tool_input":{"file_path":"~/.ssh/id_rsa"}}' | ./safety-gate.sh

set -u
input=$(cat)

tool=$(printf '%s' "$input" | /usr/bin/jq -r '.tool_name // ""')

# 機密ファイル名のパターン
secret='credentials\.json|\.secrets|id_(rsa|ed25519|ecdsa|dsa)|\.pem|\.p12|\.pfx|\.aws/credentials|\.netrc|secring'

block() {
  echo "🛑 safety-gate: 機密ファイルへのアクセスをブロックしました" >&2
  echo "   対象: $1" >&2
  echo "   意図的な操作なら ~/.claude/hooks/safety-gate.sh を見直してください。" >&2
  exit 2
}

case "$tool" in
  Read | Write | Edit | NotebookEdit | Grep)
    target=$(printf '%s' "$input" | /usr/bin/jq -r '.tool_input.file_path // .tool_input.notebook_path // .tool_input.path // ""')
    [ -z "$target" ] && exit 0
    # 公開鍵は許可
    printf '%s' "$target" | grep -qE '\.pub([[:space:]]|"|'"'"'|$)' && exit 0
    printf '%s' "$target" | grep -qE "$secret" && block "$target"
    ;;
  Bash)
    cmd=$(printf '%s' "$input" | /usr/bin/jq -r '.tool_input.command // ""')
    [ -z "$cmd" ] && exit 0
    # 読み出し・持ち出し系コマンドが機密ファイルを対象にした場合のみブロック。
    # [^|;&]* で同一コマンドセグメント内に限定し、パイプ後の grep 等は対象外にする。
    verbs='cat|less|more|head|tail|cp|scp|rsync|base64|xxd|strings|openssl|curl|nc'
    printf '%s' "$cmd" | grep -qE "($verbs)[[:space:]]+[^|;&]*($secret)" && block "$cmd"
    ;;
esac

exit 0
