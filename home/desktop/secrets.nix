{ nixosConfig, config, lib, pkgs, self, ... }:
let
  pwdPath = nixosConfig.age.secrets.keepass.path;
in
{
  services.gnome-keyring.enable = lib.mkForce false;

  systemd.user.targets.keyring = {
    Unit = {
      Description = "Home Manager Keyring";
      Requires = [ "graphical-session-pre.target" ];
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
  systemd.user.services.keepassxc = {
    Unit = {
      Description =
        "Password Manager using keepass database";
      Documentation = "https://github.com/keepassxreboot/keepassxc";
      BindsTo = [ "keyring.target" ];
      PartOf = [ "graphical-session.target" ];
      After = [ "tray.target" "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };

    Service = {
      Type = "notify";
      NotifyAccess = "all"; # So bash process can notify
      ExecStart = toString (pkgs.writeShellScript "keepassxc-with-password" ''
        PASS=$(pkexec cat ${pwdPath})
        ${pkgs.systemd}/bin/systemd-notify --ready --status="Ready"
        echo $PASS | ${pkgs.keepassxc}/bin/keepassxc \
             --pw-stdin $DATABASE_PATH
      '');
      # Give a second for keepass itself to start since
      # systemd-notify is only run after password is gotten
      ExecStartPost = "${pkgs.coreutils}/bin/sleep 1";
      Environment = "DATABASE_PATH=%h/Nextcloud/Areas/Security/Database.kdbx";
      ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      KillMode = "mixed";
    };

    # Ensure keyring.target stops if keepassxc stops
    Install = { RequiredBy = [ "keyring.target" ]; };
  };

  xdg.configFile."keepmenu/config.ini".text =
    pkgs.lib.generators.toINI {} {
      dmenu = {
        dmenu_command = "fuzzel -d";
      };
      database = {
        database_1 = "~/Nextcloud/Areas/Security/Database.kdbx";
        # Run in bash environment to expand shell variables
        password_cmd_1 = ''bash -c "pkexec cat ${pwdPath}"'';
        type_library = "ydotool";
      };
    };


  xdg.desktopEntries.keepmenu = {
    name = "Keepass Menu";
    exec = "keepmenu";
  };

  xdg.configFile."keepassxc/keepassxc.ini".text = pkgs.lib.generators.toINI {} {
    General = {
      ConfigVersion = "2";
    };
    Browser = {
      Enabled = "true";
    };
    FdoSecrets = {
      Enabled = "true";
      ConfirmAccessItem = false;
      ConfirmDeleteItem = false;
    };
    GUI = {
      MinimizeOnClose = "true";
      MinimizeOnStartup = "true";
      MinimizeToTray = "true";
      ShowTrayIcon = "true";
      TrayIconAppearance = "monochrome-light";
    };
    PasswordGenerator = {
      Length = "19";
      SpecialChars = "false";
    };
    Security = {
      LockDatabaseScreenLock = "false";
    };
  };

  home.packages = with pkgs; [
    keepmenu
    keepassxc
  ];

}
