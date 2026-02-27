# dotfiles

[![CI](https://github.com/Hina524/dotfiles/actions/workflows/ci.yaml/badge.svg)](https://github.com/Hina524/dotfiles/actions/workflows/ci.yaml)
[![Auto Update Flake](https://github.com/Hina524/dotfiles/actions/workflows/auto-update-flake.yaml/badge.svg)](https://github.com/Hina524/dotfiles/actions/workflows/auto-update-flake.yaml)

Nix Flakes + nix-darwin + home-manager によるmacOS環境の宣言的管理

## プロジェクト構造

```
.
├── systems/darwin/              # macOSシステム設定
│   ├── configurations/macOS/    #   マシン固有の設定
│   └── modules/
│       ├── homebrew.nix         #   Homebrew（casks/brews）
│       ├── macos-defaults.nix   #   macOSシステム設定
│       └── nix.nix              #   Nix本体の設定
├── home/                        # Home Manager設定
│   ├── profiles/hina/           #   ユーザープロファイル
│   └── modules/
│       ├── shell/               #   zsh, starship
│       ├── development/         #   開発ツール
│       └── ssh.nix              #   SSH接続設定
├── shared/config.nix            # 共通設定（ユーザー名、ホスト名等）
├── devshell/                    # 開発シェル
├── .github/workflows/           # CI/CD
└── flake.nix                    # Flakeエントリーポイント
```

## セットアップ

### 前提条件

- macOS
- Nix（flakesサポート付き）

### インストール

```bash
# Nixのインストール
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# リポジトリのクローン
git clone https://github.com/Hina524/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 設定を適用
sudo darwin-rebuild switch --flake .#macOS
```

以降は`rebuild`エイリアスで設定を適用できます。

## 主要なモジュール

### システム (systems/darwin/modules/)

| モジュール | 内容 |
|-----------|------|
| homebrew | GUIアプリ（casks）とCLIツール（brews）の管理 |
| macos-defaults | ダークモード、電源管理、ライブ変換OFF |
| nix | サンドボックス、並列ビルド、自動GC、ストア最適化 |

### シェル (home/modules/shell/)

| モジュール | 内容 |
|-----------|------|
| zsh | 補完、自動サジェスト、シンタックスハイライト、direnv連携 |
| starship | プロンプトカスタマイズ（ステータス表示、日本時間表示） |

### 開発ツール (home/modules/development/)

| モジュール | 内容 |
|-----------|------|
| git | ユーザー設定、エイリアス（lg, plog等） |
| github | GitHub CLI（gh） |
| php | PHP 8.4 + 拡張（pdo_pgsql, pdo_mysql, redis）+ Composer |
| laravel | Laravel + SQLite、artisan/sailエイリアス |
| nodejs | Node.js |
| terraform | Terraform |
| gcloud | Google Cloud SDK |
| ngrok | トンネリングツール |

## CI/CD

### ci.yaml - PRチェック

PRがmainブランチに対して作成されると自動実行されます。

| ジョブ | 内容 |
|-------|------|
| format-check | `nix fmt --check` によるフォーマットチェック |
| build-check | `nix build --dry-run` によるビルド評価チェック |

Branch Protection Rulesにより、両方のチェックがパスしないとマージできません。

### auto-update-flake.yaml - 依存自動更新

毎日11時(JST)に`nix flake update`を実行し、依存パッケージを最新化します。

| ステップ | 内容 |
|---------|------|
| Update flake | `nix flake update`で依存を更新 |
| Create PR | 変更があればPRを自動作成（更新されたinput一覧付き） |
| Auto-merge | CIパス後に自動マージ |

PRマージ後、ローカルで`git pull && rebuild`を実行して変更を反映してください。

### 必要なシークレット

| シークレット | 用途 |
|------------|------|
| PAT_TOKEN | PR作成・自動マージに使用するGitHub Personal Access Token |

## 方針

- **GUIアプリ** → Homebrew cask（Spotlight互換のため）
- **CLIツール** → nixpkgs or Homebrew brews
- **設定値** → `shared/config.nix`で一元管理
- **設定変更** → PR経由でCIチェック後にマージ
