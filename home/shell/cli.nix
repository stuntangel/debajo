{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables.SUDO_ASKPASS = "${pkgs.seahorse}/libexec/ssh-askpass";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs;
    [
      htop
      wget
      unzip
      git
      nix-prefetch-scripts
      nixpkgs-review
      zip
      nmap
      gitAndTools.hub
      usbutils
      nixpkgs-review
      xclip
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      universal-ctags
      ctagsWrapped.ctagsWrapped
    ];
}
