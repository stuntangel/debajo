{
  lib,
  pkgs,
  ...
}: let
  my-python-packages = python-packages:
    with python-packages; [
      pylint
      pip
      tkinter
      python-lsp-server
      # other python packages you want
    ];
  python-with-my-packages = pkgs.python3.withPackages my-python-packages;
in {

  environment.systemPackages = with pkgs; [
    python-with-my-packages
  ];

  services.openssh.enable = true;

  programs.extra-container.enable = true;

  nix.distributedBuilds = true;
  nix.settings.netrc-file = "/etc/nix/netrc";

  programs.ssh.extraConfig = ''
    Host builder
      Port 4422
      IdentitiesOnly yes
      User ryan
      HostName myrdd.info
      IdentityFile /home/ryan/.ssh/id_rsa
  '';

  environment.variables = {EDITOR = "emacs";};

  ## Program setup
  programs = {
    zsh.enable = true;
  };
}
