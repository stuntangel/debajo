{
  config,
  pkgs,
  lib,
  ...
}: {

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    image = ./espeon_wallpaper.png;
#    image = pkgs.fetchurl {
#      url = "file://${current_folder}/espeon_wallpaper.png";
#      sha256 = "1clv29qamplapqlzr0f50gaz02gqkkfnlaqknvbxnm6qfv6fdxxl";
   #   url = "https://pbs.twimg.com/media/EPh_SHMXUAEBgv_.jpg";
   #   sha256 = "0ki52h07lahzmkhn4ci5szag9wpgawhq9w0zpnkvb2svyb7rlhdm";
      #url = "https://pbs.twimg.com/media/EbcEAzpXgAAqC4I.jpg";
      #sha256 = "1vrwza30nsf7xkr8zka05ns84ym2xxl21326a517vfpm0va1kdg2";
#    };
    opacity = {
      applications = 0.9;
      desktop = 0.5;
      popups = 0.8;
      terminal = 0.7;
    };
    cursor = {
      name = "ComixCursors-Green";
      package = pkgs.comixcursors.Green;
    };
    targets.grub.useImage = true;
  };

  environment.systemPackages = with pkgs; [
    # (keepassxc.overrideAttrs (oldAttrs: {
    #   version = "fprint";
    #   buildInputs = oldAttrs.buildInputs ++ [keyutils];
    #   src = fetchFromGitHub {
    #
    #     owner = "keepassxreboot";
    #     repo = "keepassxc";
    #     rev = "500c79b02853f507e68a422e55bb6052a63e6a3e";
    #     sha256 = "L+txviZ0I6NVwdm1SJW+Mkhgdx/eNNQ/WGg59DVSo5A=";
    #   };
    # }))
  ];

  services.greetd = {
    enable = true;
    settings = let
      tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
      default_session = {
        command = "${tuigreet} --greeting 'Wassup' --asterisks --remember --remember-user-session";
      };
      gaming_session = {
        command = "gamescope -e -- steam -steamdeck -steamos3";
      };
    in {
      inherit default_session;
    };
  };

  environment.sessionVariables = rec {
    GDK_BACKEND = "wayland";
    LIBSEAT_BACKEND = "logind";
    TDESKTOP_DISABLE_GTK_INTEGRATION = "1";
    CLUTTER_BACKEND = "wayland";
    BEMENU_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";

    QT_QPA_PLATFORM = "wayland-egl";
    QT_WAYLAND_FORCE_DPI = "physical";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    ELM_DISPLAY = "wl";
    ECORE_EVAS_ENGINE = "wayland_egl";
    ELM_ENGINE = "wayland_egl";
    ELM_ACCEL = "opengl";
    ELM_SCALE = "1";

    SDL_VIDEODRIVER = "wayland";

    _JAVA_AWT_WM_NONREPARENTING = "1";

    NO_AT_BRIDGE = "1";
    WINIT_UNIX_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkIf (pkgs.system == "x86_64-linux") true;
    extraPackages = [
      pkgs.mesa.drivers
    ];
  };
  services.flatpak.enable = true;

  location.provider = "geoclue2";

  virtualisation.waydroid.enable = true;

  boot.supportedFilesystems = ["exfat"];

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = lib.mkIf (pkgs.system == "x86_64-linux") true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [hplip];
  };
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns4 = true;

  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplip];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";
}
