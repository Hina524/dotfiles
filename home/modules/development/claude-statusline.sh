#!/usr/bin/env bash
#
# Claude Code ステータスライン
#
# 機能:
#   ターミナル下部に現在のセッション情報を絵文字付き1行で表示する。
#   🤖 モデル名 + effort レベル
#   📂 カレントディレクトリ名
#   🌿 Git ブランチ（未コミット変更があれば末尾に *）
#   🧠 コンテキスト残量 %（残量ゲージバー + 使用/上限トークン数。緑>50 / 黄20-50 / 赤<20）
#   💰 セッション累計コスト ($)
#   各セグメントは │ で区切る。
#
# 設定:
#   ~/.claude/settings.json の statusLine.command からこのスクリプトを参照する。
#   入力は stdin に JSON（model / workspace / context_window / cost / effort 等）が渡る。
#
# 使用方法:
#   echo '<JSON>' | ./statusline.sh で単体テスト可能。
#   コンテキスト残量はあくまで目安（自動コンパクションの発火点は非公開）。
#
# セキュリティ:
#   JSON 由来の数値は jq 側で floor して整数化し、awk へは -v で変数渡しする。
#   awk プログラム文字列へ値を直接展開しない（コードインジェクション防止）。

set -u
input=$(cat)

# jq で1フィールド1行に抽出（数値は floor 済みの整数 / コストはそのまま数値）
# tab 区切り read は空フィールドを詰めてしまうため、行区切りで1つずつ読む（bash 3.2 でも安全）
{
  IFS= read -r model
  IFS= read -r effort
  IFS= read -r cwd
  IFS= read -r cost
  IFS= read -r remain
  IFS= read -r used
  IFS= read -r size
} < <(
  printf '%s' "$input" | /usr/bin/jq -r '
    .model.display_name // "?",
    .effort.level // "",
    (.workspace.current_dir // .cwd // ""),
    (.cost.total_cost_usd // 0),
    ((.context_window.remaining_percentage // 100) | floor),
    ((.context_window.total_input_tokens // 0)       | floor),
    ((.context_window.context_window_size // 200000) | floor)'
)

# 数値バリデーション（想定外の値はフォールバック）
is_uint() { case "$1" in '' | *[!0-9]*) return 1 ;; *) return 0 ;; esac; }
is_uint "$remain" || remain=100
is_uint "$used" || used=0
is_uint "$size" || size=200000

# ---- 色定義 ----
dim=$'\033[2m'; reset=$'\033[0m'
cyan=$'\033[36m'; blue=$'\033[34m'; magenta=$'\033[35m'
green=$'\033[32m'; yellow=$'\033[33m'; red=$'\033[31m'
sep="${dim} │ ${reset}"

# ---- ディレクトリ ----
dir=$(basename "$cwd")

# ---- Git ブランチ + dirty ----
git_seg=""
branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || true)
if [ -n "$branch" ]; then
  dirty=""
  if ! git -C "$cwd" diff --quiet --ignore-submodules 2>/dev/null \
    || ! git -C "$cwd" diff --cached --quiet --ignore-submodules 2>/dev/null; then
    dirty="*"
  fi
  git_seg="🌿 ${magenta}${branch}${dirty}${reset}${sep}"
fi

# ---- トークン整形（k / M）: awk へは -v で変数渡し ----
fmt() {
  awk -v n="$1" 'BEGIN{ if (n >= 1000000) printf "%.1fM", n/1000000; else printf "%dk", n/1000 }'
}

# ---- 残量ゲージバー（█ = 残量 / ░ = 消費。幅10）----
gauge() {
  local pct=$1 width=10 filled empty i out=""
  filled=$(((pct * width + 50) / 100))
  [ "$filled" -gt "$width" ] && filled=$width
  [ "$filled" -lt 0 ] && filled=0
  empty=$((width - filled))
  for ((i = 0; i < filled; i++)); do out="${out}█"; done
  for ((i = 0; i < empty; i++)); do out="${out}░"; done
  printf '%s' "$out"
}

# ---- コンテキスト残量の色 ----
if [ "$remain" -gt 50 ]; then ctxc=$green
elif [ "$remain" -gt 20 ]; then ctxc=$yellow
else ctxc=$red; fi

# ---- effort 接尾辞 ----
effort_seg=""
[ -n "$effort" ] && effort_seg="${dim}·${effort}${reset}"

# ---- コスト整形: awk へは -v で変数渡し ----
cost_fmt=$(awk -v c="$cost" 'BEGIN{ printf "%.2f", (c + 0) }')

# ---- コンテキストセグメント（絵文字 + % + ゲージ + トークン数）----
ctx_seg="🧠 ${ctxc}${remain}% ▕$(gauge "$remain")▏${reset} ${dim}$(fmt "$used")/$(fmt "$size")${reset}"

line="🤖 ${cyan}${model}${reset}${effort_seg}${sep}"
line="${line}📂 ${blue}${dir}${reset}${sep}"
line="${line}${git_seg}"
line="${line}${ctx_seg}${sep}"
line="${line}💰 ${dim}\$${cost_fmt}${reset}"
printf '%s\n' "$line"
