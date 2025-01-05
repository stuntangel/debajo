{ config, lib, pkgs, ... }:
let
  opacity = lib.toHexString (((builtins.ceil (config.stylix.opacity.desktop * 100)) * 255) / 100);
in
{
  imports = [ ./keybindings.nix ];

  programs.niri = {
    settings = {
      outputs."DP-3".scale = 1.5;
      outputs."DP-3".mode.width = 2560;
      outputs."DP-3".mode.height = 1440;
      outputs."DP-3".mode.refresh = 143.999;
      outputs."DP-3".position.x = 2560;
      outputs."DP-3".position.y = 100;
      outputs."eDP-1".scale = 1.5;
      prefer-no-csd = true;
      layout = {
        gaps = 20;
        border = with config.lib.stylix.colors; {
          enable = true;
          active = {
            gradient = {
              to = "#${base0D}${opacity}";
              from = "#${base0E}${opacity}";
            };
          };
          inactive = {
            color = "#${base03}${opacity}";
          };
        };
        focus-ring.enable = false;
      };

      window-rules = [
        {
          draw-border-with-background = false;
          geometry-corner-radius = let
            r = 12.0;
          in {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
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
