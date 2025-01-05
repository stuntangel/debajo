{
  self,
  config,
  pkgs,
  ...
}: {
  home-manager.users.ryan.home = {
    inherit (config.system) stateVersion;
  };

  users.mutableUsers = false;
  users.users.root.hashedPassword = "*";

  age.secrets.ryan.file = "${self}/secrets/ryan.age";
  age.secrets.keepass.file = "${self}/secrets/keepass.age";

  users.users.ryan = {
    hashedPasswordFile = "/run/agenix/ryan";
    isNormalUser = true;
    extraGroups = ["ydotool" "video" "vboxusers" "scanner" "wheel" "networkmanager" "input" "lp"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    home = "/home/ryan";
  };
}
