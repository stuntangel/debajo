{flake, pkgs, lib, ...}:
let 
  wallpapers = [
    (pkgs.fetchurl {
      url = "https://pbs.twimg.com/media/EPh_SHMXUAEBgv_.jpg";
      sha256 = "0ki52h07lahzmkhn4ci5szag9wpgawhq9w0zpnkvb2svyb7rlhdm";
    })
  ];
in
{
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${flake.inputs.tinted-theming}/base16/rose-pine-moon.yaml";
    image = builtins.elemAt wallpapers 0;
    opacity = {
      applications = 0.9;
      desktop = 0.5;
      popups = 0.2;
      terminal = 0.7;
    };
    cursor = {
      name = "ComixCursors-Green";
      package = pkgs.comixcursors.Green;
      size = 24;
    };
    targets.grub.useImage = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "niri";
        comment = "niri compositor managed by UWSM";
        binPath = lib.getExe (
          pkgs.writeShellScriptBin "niriSession" ''
            exec /run/current-system/sw/bin/niri --session
          ''
        );
      };
    };
  };

  environment.systemPackages = with pkgs; [
    keyd
    xwayland-satellite
  ];

  systemd.user.services.niri-flake-polkit = {
    wants = lib.mkForce [];
    requisite = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
  };
  
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings.global = {
        # tap wont count until timeout has passed
        # So that overview doesn't show up when trying to do another keybind
        overload_tap_timeout = 300;
      };
      settings.main = {
        leftmeta = "overload(meta, macro(leftmeta+escape))"; # Make left meta tap open overview toggle
        # Maps capslock to escape when pressed and control when held.
        capslock = "overload(control, esc)";
        # Remaps the escape key to capslock
        esc = "capslock";
      };
    };
  };
}
