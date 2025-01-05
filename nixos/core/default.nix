{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents;
in {
  nix.distributedBuilds = true;

  services.openssh.enable = true;
  services.openssh.openFirewall = lib.mkDefault false;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  environment = {
    systemPackages = with pkgs; [
      steam
      binutils
      coreutils
      curl
      direnv
      git
      nix-index
    ];

    shellInit = ''
      export STARSHIP_CONFIG=${
        pkgs.writeText "starship.toml"
        (fileContents ./starship.toml)
      }
    '';

    shellAliases = let
      ifSudo = lib.mkIf config.security.sudo.enable;
    in {
      # quick cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # git
      g = "git";

      # grep
      grep = "rg";
      gi = "grep -i";

      # internet ip
      myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

      # nix
      n = "nix";
      np = "n profile";
      ni = "np install";
      nr = "np remove";
      ns = "n search --no-update-lock-file";
      nf = "n flake";
      nepl = "n repl '<nixpkgs>'";
      srch = "ns nixos";
      orch = "ns override";
      nrb = ifSudo "sudo nixos-rebuild";
      mn = ''
        manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
      '';

      # fix nixos-option
      nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

      # sudo
      s = ifSudo "sudo -E ";
      si = ifSudo "sudo -i";
      se = ifSudo "sudoedit";

      # top
      top = "gotop";

      # systemd
      ctl = "systemctl";
      stl = ifSudo "s systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = ifSudo "s systemctl start";
      dn = ifSudo "s systemctl stop";
      jtl = "journalctl";
    };
  };

  fonts = {
    packages = with pkgs; [powerline-fonts dejavu_fonts];

    fontconfig.defaultFonts = {
      monospace = ["DejaVu Sans Mono for Powerline"];

      sansSerif = ["DejaVu Sans"];
    };
  };

  nix = {
    gc.automatic = true;
    optimise.automatic = true;

    settings = {
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      extra-sandbox-paths = ["/bin/sh=${pkgs.bash}/bin/sh"];
      auto-optimise-store = true;
      sandbox = true;
      extra-experimental-features = "flakes nix-command";
      extra-substituters = ["https://nrdxp.cachix.org" "https://nix-community.cachix.org"];
      extra-trusted-public-keys = [
        "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      allow-import-from-derivation = true;
      trusted-users = ["root" "@wheel"];
      builders-use-substitutes = true;
      min-free = 536870912;
      keep-outputs = true;
      keep-derivations = true;
      fallback = true;
    };
  };

  programs.bash = {
    promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  services.earlyoom.enable = true;
}
