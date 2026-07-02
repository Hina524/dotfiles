/*
  GitHub CLI / MCP サーバー

  提供するツール：
  - gh: GitHub CLI（issue作成、PR操作等）
  - github-mcp-server: Claude Code から GitHub を直接操作するための MCP サーバー

  設定:
  - gh の設定ファイルはnixで管理せず、既存の~/.config/gh/を使用する
  - github-mcp-server は stdio モードで動作し、gh auth token でトークンを動的取得する
  - MCP の接続設定は ~/.claude/settings.json に手動で追記する（nix 管理外）

  使用方法:
  - Claude Code 内で /mcp コマンドにより github サーバーの接続状態を確認できる
*/
{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.gh
    pkgs.github-mcp-server
  ];

  programs.zsh.initExtra = ''
    # github-mcp-server の認証トークンを gh CLI から動的取得
    if command -v gh &>/dev/null; then
      export GITHUB_PERSONAL_ACCESS_TOKEN="$(gh auth token 2>/dev/null)"
    fi
  '';
}
