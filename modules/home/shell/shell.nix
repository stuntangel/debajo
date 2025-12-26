{pkgs, ... }:
{
  home.packages = with pkgs; [
    podman
    docker-compose
    ghostty
    fprintd
    # Unix tools
    ripgrep # Better `grep`
    libgcc
    fd
    tree
    gnumake42
    wget
    unzip
    zip
    nmap
    usbutils
    binutils
    coreutils
    curl
    # Nix dev
    nix-prefetch-scripts
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
  ];

  programs = {
    ghostty = {
      enable = true;
      enableZshIntegration = true;
    };
    bash = {
      enable = true;
      initExtra = ''
        # Custom bash profile goes here
      '';
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      envExtra = ''
        # Custom ~/.zshenv goes here
      '';
      profileExtra = ''
        # Custom ~/.zprofile goes here
      '';
      loginExtra = ''
        # Custom ~/.zlogin goes here
      '';
      logoutExtra = ''
        # Custom ~/.zlogout goes here
      '';
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;

    # Better shell prompt!
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
  };
}
