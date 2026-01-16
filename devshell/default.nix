{ pkgs }:
pkgs.mkShell {
  name = "hina-nix-profile";

  packages = with pkgs; [
    alejandra
    age
    sops
    ssh-to-age
  ];
}
