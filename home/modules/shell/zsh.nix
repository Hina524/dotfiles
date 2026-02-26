/*
  シェル環境設定

  zshとシェル補助ツールを管理する：
  - zsh: 補完、自動サジェスト、シンタックスハイライト有効
  - lsd/eza: ls代替コマンド
  - bat: cat代替コマンド
  - direnv: ディレクトリ固有の環境変数管理（nix-direnv連携）
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
