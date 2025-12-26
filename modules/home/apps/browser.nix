{
 pkgs,
 ...
}: {
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      d = "https://duckduckgo.com/?q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
      np = "https://search.nixos.org/packages?query={}";
      no = "https://search.nixos.org/options?query={}";
      g = "https://www.google.com/search?hl=en&q={}";
    };
    keyBindings = {
      normal = {
        "J" = "tab-prev";
        "K" = "tab-next";
        "gJ" = "tab-move -";
        "gK" = "tab-move +";
      };
    };
  };

  stylix.targets.firefox.profileNames = ["main"];
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg.drmSupport = true;
    };
    profiles.main = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.content-properties.content.enabled" = true;
      };
    };
  };
}
