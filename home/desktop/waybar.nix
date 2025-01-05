{ config, lib, pkgs, ... }:

{

  systemd.user.services.waybar = {
    Unit = {
      BindsTo = [ "tray.target" ];
      After = lib.mkForce [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      # Ensure bar is actually configured before systemd considers this service started
      ExecStartPost = "${pkgs.coreutils}/bin/sleep 1";
    };
    Install = {
      # ensure tray.target stops if waybar stops
      RequiredBy = [ "tray.target" ];
    };
  };

  stylix.targets.waybar = {
    enableCenterBackColors = true;
    enableLeftBackColors = true;
    enableRightBackColors = true;
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "tray.target";
    };
    style = lib.mkAfter ''
      #battery.charging, #battery.plugged {
        background-color: @base0E;
      }
    '';
    settings.mainBar = {
      layer = "top";
      position = "right";
      spacing = 0;
      modules-left = [
        "wlr/taskbar"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "battery"
        "battery#icon"
        # "network" # prefer nm-applet
        # "pulseaudio" # volume icons not working
        "tray"
      ];
      "wlr/taskbar" = {
        format = "{icon}";
        tooltip-format = "{title} | {app_id}";
        on-click = "activate";
        on-click-middle = "close";
        on-click-right = "fullscreen";
      };
      tray = {
        spacing = 10;
      };
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = "{:%m\n%e\n\n<b>%H\n%M</b>}";
      };
      battery = {
        interval = 1;
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}";
        format-charging = "{capacity}";
        format-plugged = "{capacity}";
        format-alt = "{time}";
      };
      "battery#icon" = {
        interval = 1;
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} ";
        format-charging = "";
        format-plugged = "";
        format-alt = "{time}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      pulseaudio = {
        format = "{icon}";
        format-bluetooth = "{icon}";
        format-muted = "";
        format-icons = {
          default = [ "" "" ];
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          phone-muted = "";
          portable = "";
          car = "";
        };
        scroll-step = 1;
        on-click = "pavucontrol";
        ignored-sinks = [
          "Easy Effects Sink"
        ];
      };
      network = {
        format-wifi = " ";
        format-ethernet = "";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "";
        format-disconnected = "⚠";
      };
    };
  };
}
