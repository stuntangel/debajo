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
      pkgs.prismlauncher
      pkgs.stremio-linux-shell
      pkgs.pavucontrol
      pkgs.mpv
      pkgs.geeqie
    ];
}
