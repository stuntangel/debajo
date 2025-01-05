{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.kernelParams = ["mem_sleep_default=deep" "resume_offset=12550144"];

  # Suspend-then-hibernate on lid switch
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=2m";

  powerManagement = {
    enable = true;
    powertop.enable = true;
    # cpuFreqGovernor = lib.mkDefault "powersave";
  };

  services.thermald.enable = true;

  programs.auto-cpufreq.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = false;
    settings = {
      TLP_PERSISTENT_DEFAULT = 0;
      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      MAX_LOST_WORK_SECS_ON_AC = 15;
      MAX_LOST_WORK_SECS_ON_BAT = 60;
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 1;
      NMI_WATCHDOG = 0;
      DISK_DEVICES = "nvme0n1 sda";
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      DISK_IOSCHED = "keep keep";
      SATA_LINKPWR_ON_AC = "med_power_with_dipm max_performance";
      SATA_LINKPWR_ON_BAT = "med_power_with_dipm min_power";
      AHCI_RUNTIME_PM_TIMEOUT = 15;
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RADEON_POWER_PROFILE_ON_AC = "default";
      RADEON_POWER_PROFILE_ON_BAT = "default";
      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      WOL_DISABLE = "Y";
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";
      BAY_POWEROFF_ON_AC = 0;
      BAY_POWEROFF_ON_BAT = 0;
      BAY_DEVICE = "sr0";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      RUNTIME_PM_DRIVER_BLACKLIST = "amdgpu mei_me nouveau nvidia pcieport radeon";
      USB_AUTOSUSPEND = 1;
      USB_BLACKLIST_BTUSB = 0;
      USB_BLACKLIST_PHONE = 0;
      USB_BLACKLIST_PRINTER = 1;
      USB_BLACKLIST_WWAN = 0;
      USB_AUTOSUSPEND_DISABLE_ON_SHUTDOWN = 0;
      RESTORE_DEVICE_STATE_ON_STARTUP = 0;
      RESTORE_THRESHOLDS_ON_BAT = 0;
      NATACPI_ENABLE = 1;
      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;
      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;
    };
  };
}
