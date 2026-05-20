{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
#    (import ../../../overlays/anytype.nix)
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "bfc8f6edcb7bcf3cf24e4a7199b3f6fed96aaecf"; # change the revision
    }))
  ];

  systemd.user.services.vdirsyncer = {
    Unit = {
      After = [ "rbw-agent.service" ];
      Wants = [ "rbw-agent.service" ];
    };
  };
  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;

  programs.vscode = {
  enable = true;
  package = pkgs.vscode.fhsWithPackages (ps: with ps; [ avrdude ]);
  extensions = with pkgs.vscode-extensions; [
    dracula-theme.theme-dracula
    ms-python.python
    anthropic.claude-code
#    mathematic.vscode-latex
    ];
  };


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
        lmstudio
 #       anytype
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      wineWowPackages.full
    ];
}
