#!/usr/bin/env bash
#
# safety-gate hook（PreToolUse）
#
# 機能:
#   Claude Code がツールを実行する直前に呼ばれ、機密ファイルへのアクセスを
#   検出したらブロックする（exit 2）。auto モード運用の安全網。
#
# 対象ツール:
#   Read / Write / Edit / Bash / Grep（settings.json の matcher で指定）
#
# 判定:
#   - ファイル系ツールは file_path / path を、Bash は command 文字列を検査する
#   - 機密パターン（SSH 秘密鍵・credentials.json・.pem 等）に一致したらブロック
#   - 公開鍵（.pub）は許可
#   - .env / .envrc は direnv 運用のため意図的に許可（ブロックしない）
#
# 設定:
#   home.file で ~/.claude/hooks/safety-gate.sh にデプロイし、
#   ~/.claude/settings.json の hooks.PreToolUse に手動で登録する。
#
# 使用方法（テスト）:
#   echo '{"tool_name":"Read","tool_input":{"file_path":"~/.ssh/id_rsa"}}' | ./safety-gate.sh

set -u
input=$(cat)

# 検査対象の文字列（ツールごとに見る場所が違う）
target=$(printf '%s' "$input" | /usr/bin/jq -r '
  .tool_input.file_path // .tool_input.path // .tool_input.command // ""
')

[ -z "$target" ] && exit 0

# 公開鍵は許可（秘密鍵パターンより先に判定）
if printf '%s' "$target" | grep -qE '\.pub([[:space:]]|"|'"'"'|$)'; then
  exit 0
fi

# 機密パターン
patterns='credentials\.json|\.secrets|(^|/)id_(rsa|ed25519|ecdsa|dsa)|\.pem|\.p12|\.pfx|\.aws/credentials|(^|/)\.netrc|secring'

if printf '%s' "$target" | grep -qE "$patterns"; then
  echo "🛑 safety-gate: 機密ファイルへのアクセスをブロックしました" >&2
  echo "   対象: $target" >&2
  echo "   意図的な操作なら ~/.claude/hooks/safety-gate.sh のパターンを見直してください。" >&2
  exit 2
fi

exit 0
