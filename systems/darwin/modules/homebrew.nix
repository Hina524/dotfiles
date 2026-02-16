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
      "1password"
      "1password-cli"
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
