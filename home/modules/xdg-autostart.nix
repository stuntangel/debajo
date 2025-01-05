{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.xdg.autoStart;
  copyCommands =
    map
    (i: "cp -r ${i}/share/applications/* .")
    cfg.packages;
  entriesDir = pkgs.runCommand "autostart-desktop-entires" {} ''
    mkdir -p $out
    ${concatStringsSep "\n" (map (p: ''
        if cp -r ${p}/share/applications/* $out/; then
          echo ${p.name} successfully included in autostart directory
        else
          echo unable to include ${p.name} in autostart directory
        fi
      '')
      cfg.packages)}
  '';
in {
  options = {
    xdg.autoStart = {
      enable = mkEnableOption "manage .config/autostart";
      packages = mkOption {
        type = with types; listOf package;
        description = ''
          packages to add to .config/autostart
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."autostart".source = entriesDir;
  };
}
