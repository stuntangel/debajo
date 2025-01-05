{
  config,
  pkgs,
  self,
  ...
}: {

   nixpkgs.overlays = [
    (_: prev: {
      gamescope = prev.gamescope.overrideAttrs (_: rec {
        version = "3.14.29";
        src = prev.fetchFromGitHub {
          owner = "ValveSoftware";
          repo = "gamescope";
          rev = "refs/tags/${version}";
          fetchSubmodules = true;
          hash = "sha256-q3HEbFqUeNczKYUlou+quxawCTjpM5JNLrML84tZVYE=";
        };
      });
    })
  ];

  home.packages = with pkgs; [
      (pkgs.callPackage ./celeste/package.nix {}) 
      pkgs.prismlauncher
      pkgs.gamescope
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      lutris
      (pkgs.steam.override {extraLibraries = pkgs: [pkgs.pipewire];})
    ];
}
