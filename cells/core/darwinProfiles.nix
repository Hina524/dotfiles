{
  inputs,
  cell,
}:
{
  default = {
    system.stateVersion = 5;

    nix.settings.sandbox = true;
    nix.settings.trusted-users = [ "@admin" ];
    nix.settings.allowed-users = [ "@admin" ];
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # nix.useDaemon = true;
    security.pam.services.sudo_local.touchIdAuth = true;
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
        "xquartz"
        "astah-professional"
        "sf-symbols"
      ];
    };
  };

  optimize = {
    # https://wiki.nixos.org/wiki/Storage_optimization

    nix.optimise.automatic = true;
    nix.gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };
}
