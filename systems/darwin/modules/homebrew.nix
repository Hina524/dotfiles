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
      "figma"
      "warp"
      "xquartz"
      "astah-professional"
      "sf-symbols"
    ];
  };
}
