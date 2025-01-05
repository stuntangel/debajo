{
  config,
  pkgs,
  ...
}: let
  gnome-theme = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v94";
    sha256 = "1f595kznldd7r0ay6km6zlf9m76syg85x7h3z3njk6c36w93x7xw";
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg.drmSupport = true;
    };
    profiles.main = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        keepassxc-browser
      ];

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.content-properties.content.enabled" = true;
      };
    };
  };

  home.packages = with pkgs; [
  ];
}
