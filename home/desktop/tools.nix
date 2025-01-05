{ config, lib, pkgs, ... }:

{
  services.swaync = {
    enable = true;
  };

  systemd.user.services."swaybg" = {
    Unit = {
      Description = "wallpapers! brought to you by stylix! :3";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  services.swayosd = {
    enable = true;
  };
  systemd.user.services.swayosd = {
    Unit.Requisite = [ "graphical-session.target" ];
  };

  programs.fuzzel.enable = true;
  programs.swaylock.enable = true;

  services.network-manager-applet.enable = true;
  systemd.user.services.network-manager-applet = {
    Unit.After = [ "graphical-session.target" "keyring.target" ];
  };

  services.cliphist.enable = true;
  systemd.user.services.cliphist.Unit = {
    After = [ "graphical-session.target" ];
    Requisite = [ "graphical-session.target" ];
  };
  systemd.user.services.cliphist-images.Unit = {
    After = [ "graphical-session.target" ];
    Requisite = [ "graphical-session.target" ];
  };

  xdg.configFile."networkmanager-dmenu/config.ini".text =
    pkgs.lib.generators.toINI {} {
      dmenu = {
        dmenu_command = "fuzzel -d";
      };
    };

  home.sessionVariables = {
    # for rofi-systemd
    ROFI_SYSTEMD_ROFI_COMMAND = "fuzzel -d -p";
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
    networkmanagerapplet
    networkmanager_dmenu
    (rofi-bluetooth.overrideAttrs (oldAttrs: {
      postInstall = ''
        sed -i -E 's/(rofi_command=).*/\1"fuzzel -d"/' $out/bin/.rofi-bluetooth-wrapped
        sed -i -E 's/bluetoothctl scan on/bluetoothctl --timeout 5 scan on/' $out/bin/.rofi-bluetooth-wrapped
      '';
    }))
    (rofi-systemd.overrideAttrs (old: {
      version = "unstable-2023-09-04";
      src = fetchFromGitHub {
        owner = "IvanMalison";
        repo = "rofi-systemd";
        rev = "66ff2d7361368970a722a02c61e51828935d24b3";
        sha256 = "sha256-TO9O+4OJMeb+VbQsNwvzKa1UNuP95n36FOiQeIrzUPc=";
      };
      # remove rofi specific keybinding feature usage
      installPhase = old.installPhase + ''
        sed -i '/-kb-custom/d' $out/bin/rofi-systemd
        sed -i '/"systemd unit: "/s/ \\/)/' $out/bin/rofi-systemd

      '';
    }))
    (pkgs.writeShellScriptBin "cliphist-paste" ''
      ${pkgs.cliphist}/bin/cliphist list \
        | ${pkgs.fuzzel}/bin/fuzzel -d \
        | ${pkgs.cliphist}/bin/cliphist decode \
        | ${pkgs.wl-clipboard}/bin/wl-copy
    '')
  ];
}
