{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    serverAliveInterval = 20;
  };

  home.packages = [];
}
