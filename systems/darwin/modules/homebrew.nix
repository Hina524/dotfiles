/*
  Homebrew パッケージ管理

  GUIアプリ（casks）とCLIツール（brews）をHomebrewで管理する
  rebuild時に自動更新・アップグレード・不要パッケージの削除（zap）を行う
  Homebrew (/opt/homebrew/bin) をシステム PATH に追加してユーザーシェルから利用可能にする
*/
{ config, pkgs, ... }:
{
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      # `brew bundle --cleanup`は確認プロンプトをスキップするため`--force`が必須
      extraFlags = [ "--force" ];
    };
    brews = [
      "swiftlint"
      "xcodegen"
      "fastlane"
      "go"
      "ktlint"
      "mpv"
    ];
    casks = [
      "discord"
      "figma"
      "google-chrome"
      "obsidian"
      "sf-symbols"
      "slack"
      "swiftbar"
      "visual-studio-code"
      "warp"
      "xquartz"
      "zotero"
    ];
  };
}
