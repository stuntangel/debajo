{
  lib,
  config,
  pkgs,
  ...
}: {
  nix.package = lib.mkForce pkgs.nix;
  home.packages = with pkgs;
    [
      pulseaudio
      pavucontrol
      vlc
      mpv
      cheese
      krita
    ]
    ++ lib.optionals (pkgs.system != "aarch64-linux") [
      stremio
    ];
}
