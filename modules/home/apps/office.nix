{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  systemd.user.services.vdirsyncer = {
    Unit = {
      After = [ "rbw-agent.service" ];
      Wants = [ "rbw-agent.service" ];
    };
  };
  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;

  systemd.user.services.rbw-agent = {
    Unit = {
      Description = "Agent for rbw";
      Documentation = "https://github.com/doy/rbw";
    };

    Service = {
      ExecStart = "${pkgs.rbw}/bin/rbw-agent --no-daemonize";
      Type = "simple";
      # /run/user/$UID for the socket
      ReadWritePaths = [ "%t" ];
    };
    Install.WantedBy = [ "default.target" ];
  };

  home.packages = with pkgs;
    [
        vdirsyncer
        texlivePackages.dvisvgm
        texliveFull
        rbw
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      wineWowPackages.full
    ];
}
