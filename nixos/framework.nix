{
  self,
  modulesPath,
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    [
      # Include the results of the hardware scan.
      "${modulesPath}/installer/scan/not-detected.nix"
    ]
    ++ self.nixosSuites.below;

  home-manager.users.ryan = {
    imports = self.homeSuites.below;
  };

  networking.networkmanager.enable = !config.networking.wireless.enable;

  services.fwupd.enable = true;

  networking.hostName = "ryan"; # Define your hostname.

  # boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.fprintd.enable = true;

  ## BootLoader configuration
  boot.loader.grub = {
    enable = true;
    configurationLimit = 20;
    efiInstallAsRemovable = true;
    devices = ["nodev"];
    efiSupport = true;
    fsIdentifier = "uuid";
  };

  system.stateVersion = "24.05";

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "i915.force_probe=46a6" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2fd32f3f-014d-4c7f-a895-43a11cdc7ecd";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2F7E-C272";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  swapDevices = [ ];

  hardware.graphics.enable32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
