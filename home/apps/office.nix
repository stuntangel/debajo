{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-toolsai.jupyter
      ms-python.python
      mkhl.direnv
    ];
  };

  home.file.".config/matlab/nix.sh".text = ''
    INSTALL_DIR=$HOME/bins/MatlabR2024b
  '';

  programs.alacritty.enable = true;

  home.packages = with pkgs;
    [
      zotero-beta
      inputs.nix-matlab.packages.x86_64-linux.matlab
      hunspell
      hunspellDicts.en-us-large
      sarasa-gothic
      alegreya-sans
      texlivePackages.dvisvgm
      texliveFull
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      wineWowPackages.full
    ];
}
