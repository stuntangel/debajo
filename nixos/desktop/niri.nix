{
  lib,
  pkgs,
  ...
}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  systemd.user.services.niri-flake-polkit = {
    wants = lib.mkForce [];
    requisite = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };
}
