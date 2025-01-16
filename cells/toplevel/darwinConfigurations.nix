{
  inputs,
  cell,
}: {
  macOS = {
    bee = {
      system = "aarch64-darwin";
      pkgs = inputs.nixpkgs;
      home = inputs.home-manager;
      darwin = inputs.nix-darwin;
    };

    imports = [
      inputs.cells.core.darwinProfiles.default
      inputs.cells.core.darwinProfiles.optimize
    ];

    home-manager.users.hina = {
      imports = [
        inputs.cells.core.homeProfiles.default

        inputs.cells.dev.homeProfiles.git
        inputs.cells.dev.homeProfiles.zsh
        inputs.cells.dev.homeProfiles.jdk23
        inputs.cells.dev.homeProfiles.vscode
        # inputs.cells.dev.homeProfiles.ruby
        inputs.cells.dev.homeProfiles.build_tools
        inputs.cells.dev.darwinProfiles.xcode

        inputs.cells.hina.homeProfiles.default
        inputs.cells.hina.darwinProfiles.default
      ];
    };

    users.users = {
      hina = {
        createHome = true;
        home = "/Users/hina";
        shell = inputs.nixpkgs.pkgs.zsh;
      };
    };
  };
}
