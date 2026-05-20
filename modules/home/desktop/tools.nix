{
  flake,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ({ modulesPath, ... }: {
      imports = [ flake.inputs.anyrun.homeManagerModules.default ];
      disabledModules = ["${modulesPath}/programs/anyrun.nix"];
    })
  ];
  programs.anyrun = {
    enable = true;
    daemon.enable = true;
    config = {
      y.absolute = 35;
      layer = "top";
      plugins = with flake.inputs.anyrun.packages; [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libdictionary.so"
        "${pkgs.anyrun}/lib/libkidex.so"
        "${pkgs.anyrun}/lib/libniri-focus.so"
        "${pkgs.anyrun}/lib/libnix-run.so"
        "${pkgs.anyrun}/lib/librandr.so"
        "${pkgs.anyrun}/lib/librink.so"
        "${pkgs.anyrun}/lib/libshell.so"
        "${pkgs.anyrun}/lib/libstdin.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
        "${pkgs.anyrun}/lib/libtranslate.so"
        "${pkgs.anyrun}/lib/libwebsearch.so"
      ];
    };
    extraCss = ''
      window {
        background: transparent;
      }

      box.main {
        padding: 5px;
        margin: 10px;
        border-radius: 10px;
        border: 2px solid @theme_selected_bg_color;
        background-color: @theme_bg_color;
        box-shadow: 0 0 5px black;
        opacity: 0.8;
      }
    '';
  };

  services.swayosd = {
    enable = true;
  };
  systemd.user.services.swayosd = {
    Unit.Requisite = ["graphical-session.target"];
  };

  programs.rofi.enable = true;
  programs.rofi.package = pkgs.rofi;
  programs.rofi.theme = let
    inherit (config.lib.formats.rasi) mkLiteral;
  in
    with config.lib.stylix.colors; {
      "*" = {
        border-radius = 5;
        background-color = lib.mkForce (mkLiteral "#${base00}");
        lightbg = lib.mkForce (mkLiteral "#${base01}");
        blue = lib.mkForce (mkLiteral "#${base0D}");
        selected-normal-background = lib.mkForce (mkLiteral "@blue");
      };
      window = {
        background-image = mkLiteral "linear-gradient(#${base0E}7F, #${base0D}7F)";
      };
    };

  programs.swaylock.enable = true;

  services.network-manager-applet.enable = true;
  systemd.user.services.network-manager-applet = {
    Unit.After = ["graphical-session.target" "keyring.target"];
  };

  services.cliphist.enable = true;
  systemd.user.services.cliphist.Unit = {
    After = ["graphical-session.target"];
    Requisite = ["graphical-session.target"];
  };
  systemd.user.services.cliphist-images.Unit = {
    After = ["graphical-session.target"];
    Requisite = ["graphical-session.target"];
  };

  xdg.desktopEntries = {
    rofi-bluetooth = {
      name = "Bluetooth Rofi";
      exec = "rofi-bluetooth";
      icon = "bluetooth";
    };
    rofi-systemd = {
      name = "Systemd Rofi";
      exec = "rofi-systemd";
      icon = "preferences-system-services";
    };
    cliphist-paste = {
      name = "Cliphist Paste";
      exec = "cliphist-paste";
      icon = "clipboard";
    };
  };

  home.packages = with pkgs; [
    wl-clipboard
    rofi-bluetooth
    networkmanagerapplet
    networkmanager_dmenu
    rofi-systemd
    (pkgs.writeShellScriptBin "cliphist-paste" ''
      ${pkgs.cliphist}/bin/cliphist list \
        | ${pkgs.rofi}/bin/rofi -dmenu \
        | ${pkgs.cliphist}/bin/cliphist decode \
        | ${pkgs.wl-clipboard}/bin/wl-copy
    '')
  ];
}
