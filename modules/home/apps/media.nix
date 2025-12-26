{
  lib,
  config,
  flake,
  pkgs,
  ...
}:
{
  home.packages =
    [
      pkgs.steam
      pkgs.stremio
      pkgs.pavucontrol
      pkgs.mpv
      pkgs.geeqie
    ];
}
