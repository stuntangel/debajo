{ flake, config, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    flake.inputs.agenix.homeManagerModules.age
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = {
    username = "ryan";
    fullname = "Ryan Niemi";
    email = "niemiryan@gmail.com";
  };

  age.secrets.ryan.file = "${self}/secrets/ryan.age";
   
  home.stateVersion = "25.11";
}
