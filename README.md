# hina-nix-profile

Nix Flakesを使ったmacOS環境の宣言的管理

## 構成

```
home/
├── modules/           # 再利用可能なモジュール
│   ├── development/   # git, vscode
│   └── shell/         # zsh, starship, direnv, bat, eza
└── profiles/
    └── hina/          # ユーザー設定

systems/
└── darwin/
    ├── configurations/
    │   └── macOS/     # マシン設定
    └── modules/       # homebrew, nix設定

devshell/              # 開発シェル
```

## セットアップ

```bash
# 1. Nix flakesを有効化
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 2. 設定を適用
darwin-rebuild switch --flake .#macOS
```

## 管理対象

| カテゴリ | 内容 |
|---------|------|
| システム | Homebrew, Nix設定, Touch ID認証 |
| シェル | zsh, starship, direnv, bat, eza, lsd |
| 開発ツール | git, vscode, jdk21, claude-code, nil, nixd |
| アプリ | Discord, Slack, Obsidian, Chrome, Warp |

## 使い方

```bash
# 設定を適用
darwin-rebuild switch --flake .#macOS

# 開発シェルに入る
nix develop
```
