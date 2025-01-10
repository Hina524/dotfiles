{
  inputs,
  cell,
}:
{
  xcode =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        xcodes
      ];
    };
}
