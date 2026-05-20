{
  lib,
  config,
  pkgs,
  ...
}: {

  home.packages = with pkgs;
    [
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      slack
      zoom-us
    ];
}
