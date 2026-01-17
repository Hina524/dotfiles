{ pkgs, sharedConfig }:
pkgs.mkShell {
  name = "${sharedConfig.username}-nix-profile";

  packages = with pkgs; [
    alejandra
    age
    sops
    ssh-to-age
  ];
}
