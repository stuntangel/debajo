# A module that automatically imports everything else in the parent folder.
{ lib, pkgs, ... }:
let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
in
{
  imports = 
#    [
#      ./apps/matlab
#    ] ++
    filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./.))
  );

    options.programs.enable = lib.mkEnableOption "Setup GUI Modules";

#  config = lib.mkIf config.programs.enable {
#    programs.packages.enable = lib.mkDefault true;
#  };
}
