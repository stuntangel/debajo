{flake, lib, config, pkgs, ...}: let
  mkCornerRadius = r: {
    top-left = r;
    top-right = r;
    bottom-left = r;
    bottom-right = r;
  };
in {
  imports = [
    ./keybindings.nix
    flake.inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    flake.inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];

  nixpkgs.overlays = [ flake.inputs.niri-flake.overlays.niri ];
  
  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;
    niri = {
      enableKeybinds = true;
    };
    plugins =
      let
        dmsPlugins = pkgs.fetchFromGitHub {
          owner = "AvengeMedia";
          repo = "dms-plugins";
          rev = "db7ab54d1899e5339e9d5a06c84d5685116cf34b";
          hash = "sha256-LepGE6y32KjHgEPQbkymWFkfYCdfse/Lc6tLtbzH9r0=";
        };
      in {
        DankBatteryAlerts.src = "${dmsPlugins}/DankBatteryAlerts";
      };
  };
  systemd.user.services.dms = {
    Service.Environment = [
      "QT_QPA_PLATFORM=wayland"
    ];
  };

  programs.niri = {
    settings = {
      outputs."eDP-1".scale = 1.5;
      prefer-no-csd = true;
      layout = {
        gaps = 20;
        background-color = "transparent";
        border = with config.lib.stylix.colors; {
          enable = true;
          active = {
            gradient = {
              to = base0D;
              from = base0E;
            };
          };
          inactive = {
            color = base03;
          };
        };
        focus-ring.enable = false;
      };
      overview = {
        zoom = 0.3;
      };
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };

      layer-rules = [
        {
          matches = [
            {namespace = "^quickshell$";}
          ];
          place-within-backdrop = true;
        }
      ];

      window-rules = [
        {
          draw-border-with-background = false;
          geometry-corner-radius = mkCornerRadius 12.0;
          clip-to-geometry = true;
        }
      ];

      input = {
        keyboard.xkb.layout = "us";
        touchpad = {
          tap = true;
          click-method = "clickfinger";
        };
      };
    };
  };
}
