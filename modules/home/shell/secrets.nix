{pkgs, ...}: {
  systemd.user.targets.keyring = {
    Unit = {
      Description = "Home Manager Keyring";
      # Requires = ["graphical-session-pre.target"];
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  home.packages = with pkgs; [
    gcr
    bitwarden-desktop
    ((rofi-rbw.override {waylandSupport = true;}).overrideAttrs (final: prev: {
      version = "1.5.1";
      src = fetchFromGitHub {
        owner = "";
        repo = "rofi-rbw";
        tag = "1.5.1";
        hash = "sha256-Qdbz3UjWMCuJUzR6UMt/apt+OjMAr2U7uMtv9wxEZKE=";
      };
      propagatedBuildInputs = prev.propagatedBuildInputs ++ [python3Packages.hatchling];
    }))
  ];

  xdg.configFile."rofi-rbw.rc".text = ''
    keybindings Alt+a:type:username:tab:password,Alt+u:type:username,Alt+p:type:password,Alt+t:type:totp,Alt+P:copy:password,Alt+U:copy:username,Alt+T:copy:totp,Alt+M::menu
  '';
  home.sessionVariablesExtra = ''
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/rbw/ssh-agent-socket"
  '';
  programs.rbw.enable = true;
  programs.rbw.settings = {
    base_url = "https://vault.lucky.info";
    email = "niemiryan@gmail.com";
    ui_url = "https://vault.lucky.info";
    pinentry = pkgs.pinentry-rofi;
  };
}
