{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    junction
  ];

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
      # Any service starting after tray.target also
      # needs to start after "graphical-session.target"
      # to prevent cyclic dependency
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # file keeps getting overwritten
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/file" = "re.sonny.Junction.desktop";
    };
  };
}
