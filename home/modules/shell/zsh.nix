/*
  シェル環境設定

  zshとシェル補助ツールを管理する：
  - zsh: 補完、自動サジェスト、シンタックスハイライト有効
  - lsd/eza: ls代替コマンド
  - bat: cat代替コマンド
  - direnv: ディレクトリ固有の環境変数管理（nix-direnv連携）

  ローカル設定:
  - ~/.zshrc.local があれば読み込む（実行時チェック）
  - リポジトリに含めたくないマシン固有・PII を含む設定の置き場（追跡しない実ファイル）
  - $HOME 直下に置く理由: dotDir(~/.config/zsh) は home-manager 管理下で
    rebuild 時に手置きファイルが消えるため、管理外の $HOME に逃がす
*/
{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    dotDir = "${config.xdg.configHome}/zsh";
    shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake ~/dotfiles#macOS";
    };
    initContent = ''
      # リポジトリ外のマシンローカル設定（存在すれば読み込む）
      # $HOME 直下に置く（dotDir 内だと rebuild で消えるため）
      [[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
    '';
  };

  programs.lsd = {
    enable = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.bat = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
    enableBashIntegration = true;
  };
}
