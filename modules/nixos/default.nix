# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, config, pkgs, lib, ... }:
{
  imports = [
    flake.inputs.self.nixosModules.common
    flake.inputs.stylix.nixosModules.stylix
    flake.inputs.dankMaterialShell.nixosModules.greeter
#   flake.inputs.kooky.homeModules.default
    ({pkgs, ...}: {
      imports = [flake.inputs.niri-flake.nixosModules.niri];
      niri-flake.cache.enable = false;
    })
  ];

#  programs.kooky = {
#    enable = true;
#    enableDaemon = true;        # Default: Emacs daemon with emacsclient
#    includeRuntimeDeps = true;  # Default: LSP servers, fonts, CLI tools
#  };

  services.upower.enable = true;

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };



  services.openssh.enable = true;
  services.openssh.openFirewall = lib.mkDefault false;
  services.libinput.enable = true;
  services.acpid.enable = true;
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;
  services.power-profiles-daemon.enable = true; # Enables powerprofilesctl for terminal-based power mode switching
  services.fwupd.enable = true;
  environment.etc."fwupd/fwupd.conf".text = lib.mkForce ''
    [fwupd]
    UpdateOnBoot=true
  '';

  services.fprintd.enable = true;
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
  };

  boot.supportedFilesystems = ["exfat"];

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = lib.mkIf (pkgs.system == "x86_64-linux") true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    tuigreet
    config.stylix.cursor.package
  ];

  programs.dankMaterialShell.greeter = {
    enable = true;
    configHome = "/home/ryan/";
    compositor.name = "niri";
    compositor.customConfig = ''
      output "eDP-1" {
        scale 1.5
        transform "normal"
      }
      cursor {
        xcursor-theme "ComixCursors-Green"
        xcursor-size 24
      }
    '';
    logs.save = true;
  };

  services.greetd = {
    enable = true;
    settings = let
      tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      default_session = {
        command = "${tuigreet} --greeting 'Lucky' --asterisks --remember --remember-user-session";
      };
    in {
      inherit default_session;
    };
  };
}
