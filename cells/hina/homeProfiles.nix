{
  inputs,
  cell,
}: {
  default = {pkgs, ...}:  {
    home.packages = with pkgs; [
      nerd-fonts.fira-code
      nil
      nixd
      nixfmt-rfc-style
      warp-terminal
      discord
      slack
      obsidian
      google-chrome
    ];

    fonts.fontconfig.enable = true;
  };
}