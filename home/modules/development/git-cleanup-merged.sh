#!/usr/bin/env bash
# マージ済みのローカルブランチを削除する（git cleanup エイリアスの実体）。
#
# merge commit 運用と squash 運用の両方に対応する。
#   - merge commit: git 自身が --merged で判定できる。-d を使うので未マージなら git が拒否する
#   - squash:       git では判定できない（元のコミットが main に含まれないため）。
#                   GitHub に問い合わせ、以下の両方を満たすものだけ -D で削除する
#                     1. その名前のブランチを head とする PR がマージ済み
#                     2. ローカルの先端が PR の head と完全に一致する
#
# 2 の一致確認が安全装置。squash 済みブランチは -d では消せないため -D が必要になるが、
# -D は未マージのコミットも消す。PR head と一致していれば、ローカルにしか無いコミットは
# 存在しないと言い切れる。名前を再利用したブランチを誤って消すことも防げる。
#
# 使い方:
#   git cleanup            削除する
#   git cleanup --dry-run  削除せず対象だけ表示する
set -uo pipefail

readonly MAIN_BRANCH=main
readonly PR_FETCH_LIMIT=300

dry_run=0
if [ "${1:-}" = "--dry-run" ]; then
  dry_run=1
  echo "[dry-run] 削除は行わない"
fi

current=$(git branch --show-current 2>/dev/null || true)

if ! git rev-parse --verify --quiet "$MAIN_BRANCH" >/dev/null; then
  echo "エラー: ブランチ '$MAIN_BRANCH' が存在しない" >&2
  exit 1
fi

# git 自身が判定できる分（merge commit 運用）
merged_by_git=$(git branch --merged "$MAIN_BRANCH" --format='%(refname:short)' 2>/dev/null || true)

# GitHub に問い合わせる分（squash 運用）。失敗したら黙って諦めず、その旨を出す。
gh_ok=0
merged_prs=""
if command -v gh >/dev/null 2>&1 && git remote get-url origin >/dev/null 2>&1; then
  if merged_prs=$(gh pr list --state merged --limit "$PR_FETCH_LIMIT" \
    --json headRefName,headRefOid -q '.[] | "\(.headRefName) \(.headRefOid)"' 2>/dev/null); then
    gh_ok=1
  fi
fi
if [ "$gh_ok" -eq 0 ]; then
  echo "注意: GitHub に問い合わせできないため、merge commit 運用の分のみ対象にする" >&2
fi

# ループ中に git branch の出力が変わらないよう、先に確定させる
branches=$(git branch --format='%(refname:short)')

deleted=0
skipped=0

while IFS= read -r branch; do
  [ -z "$branch" ] && continue
  [ "$branch" = "$MAIN_BRANCH" ] && continue
  [ "$branch" = "$current" ] && continue

  # merge commit 運用: git の判定に従う。-d なので安全側に倒れる
  if printf '%s\n' "$merged_by_git" | grep -qxF -- "$branch"; then
    if [ "$dry_run" -eq 1 ]; then
      printf '  %-42s %s\n' "$branch" "main にマージ済み"
    else
      git branch -d -- "$branch" >/dev/null 2>&1 &&
        printf '  削除 %-37s %s\n' "$branch" "main にマージ済み"
    fi
    deleted=$((deleted + 1))
    continue
  fi

  [ "$gh_ok" -eq 0 ] && continue

  pr_oid=$(printf '%s\n' "$merged_prs" | awk -v n="$branch" '$1 == n { print $2; exit }')
  [ -z "$pr_oid" ] && continue

  local_oid=$(git rev-parse --verify --quiet "$branch" || true)
  if [ -n "$local_oid" ] && [ "$local_oid" = "$pr_oid" ]; then
    if [ "$dry_run" -eq 1 ]; then
      printf '  %-42s %s\n' "$branch" "squash マージ済み（PR head と一致）"
    else
      git branch -D -- "$branch" >/dev/null 2>&1 &&
        printf '  削除 %-37s %s\n' "$branch" "squash マージ済み（PR head と一致）"
    fi
    deleted=$((deleted + 1))
  else
    printf '  スキップ %-33s %s\n' "$branch" "PR はマージ済みだがローカルの先端が一致しない"
    skipped=$((skipped + 1))
  fi
done <<<"$branches"

if [ "$deleted" -eq 0 ] && [ "$skipped" -eq 0 ]; then
  echo "削除対象なし"
fi
exit 0
