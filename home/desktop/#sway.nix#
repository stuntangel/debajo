{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wayland.windowManager.sway;
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      terminal = "${pkgs.alacritty}/bin/alacritty";
    };
  };
  home.packages = with pkgs; [
    pavucontrol
    pw-volume
  ];
}
