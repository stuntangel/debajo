{
  config,
  pkgs,
  lib,
  ...
}: {
  qt.platformTheme = "gtk";

  # Lets you add fonts to home.packages
  # Auto updates font cache
  fonts.fontconfig.enable = lib.mkForce true;

  # Fonts and Icons
  home.packages = with pkgs; [
    nerdfonts
    wineWowPackages.fonts
    iosevka
    font-awesome
    siji
    noto-fonts
    corefonts
    papirus-icon-theme
  ];

  gtk.iconTheme = {
    name = "Papirus";
    package = pkgs.papirus-icon-theme;
  };
}
