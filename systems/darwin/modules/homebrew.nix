/*
  Homebrew パッケージ管理

  GUIアプリ（casks）とCLIツール（brews）をHomebrewで管理する
  rebuild時に自動更新・アップグレード・不要パッケージの削除（zap）を行う
*/
{ config, pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "swiftlint"
      "xcodegen"
      "fastlane"
      "go"
      "rbenv"
      "ktlint"
    ];
    casks = [
      "discord"
      "figma"
      "google-chrome"
      "obsidian"
      "sf-symbols"
      "slack"
      "visual-studio-code"
      "warp"
      "xquartz"
    ];
  };
}
