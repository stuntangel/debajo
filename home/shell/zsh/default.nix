{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    # Shell Aliases(aliases)
    shellAliases = {
      cg = "gcalcli --config-folder ~/.config/gcalcli/";
      usctl = "systemctl --user";
      sctl = "sudo systemctl";
      hm = "home-manager";
      nir = "sudo nixos-rebuild";
      eh = "vim ~/.config/nixpkgs/home.nix";
      esc = "sudo vim /etc/nixos/configuration.nix";
      android-mount = "nix-shell -p libmtp jmtpfs --run jmtpfs";
      android-unmount = "nix-shell -p libmtp jmtpfs --run fusermount -u";
      ducks = "du -hsx * | sort -rh | head -10";
    };
    plugins = with import ./zshPlugins/generated.nix pkgs; [
      {
        name = "z";
        file = "z.sh";
        src = z;
      }
      {
        name = "zsh-bd";
        src = zsh-bd;
      }
      {
        name = "zsh-autosuggestions";
        src = zsh-autosuggestions;
      }
      {
        name = "zsh-history-substring-search";
        src = zsh-history-substring-search;
      }
      {
        name = "zsh-completions";
        src = zsh-completions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = zsh-syntax-highlighting;
      }
    ];
  };
}
