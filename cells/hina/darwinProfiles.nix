{
  inputs,
  cell,
}: {
  default = {pkgs, ...}:  {
    home.packages = with pkgs; [
      arc-browser
    ];
  };
}