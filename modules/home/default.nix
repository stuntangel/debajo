# A module that automatically imports everything else in the parent folder.
{ lib, pkgs, ... }:
let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
in
{
  imports = 
    filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./.))
  );
}
