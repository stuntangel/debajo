{
  description = "A highly structured configuration database.";

  nixConfig.extra-substituters = "https://niri.cachix.org";
  nixConfig.extra-trusted-public-keys = ''
    niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=
  '';

  inputs = {
    nixos.url = "nixpkgs/nixos-unstable";
    nixpkgs.follows = "nixos";

    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea.url = "github:nix-community/haumea";

    home.url = "github:nix-community/home-manager";
    agenix.url = "github:ryantm/agenix";
    nur.url = "nur";
    nixos-hardware.url = "nixos-hardware";
    nixos-wsl.url = "github:nix-community/nixos-wsl";

    auto-cpufreq.url = "github:AdnanHodzic/auto-cpufreq";
    niri-flake.url = "github:sodiboo/niri-flake";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    stylix.url = "github:danth/stylix";
    # niri-flake.inputs.nixpkgs.follows = "nixos";

    devshell.url = "github:numtide/devshell";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };
  };

  outputs = { self, nixpkgs, haumea, nix-matlab, emacs-overlay, ... } @ inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({getSystem, ...}: {
      imports = [
        inputs.devshell.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = ["aarch64-linux" "x86_64-linux"];


      perInput = system: flake:
      # Include vscode extensions in inputs'
        nixpkgs.lib.optionalAttrs (flake ? extensions.${system}) {
          extensions = flake.extensions.${system};
        };

      perSystem = {
        inputs',
        pkgs,
        ...
      }: {
        treefmt = {
          programs.alejandra.enable = true;
          flakeFormatter = true;
          projectRootFile = "flake.nix";
        };

        devshells.default = {pkgs, ...}: {
          commands = [
            {package = pkgs.nix;}
            {package = inputs'.agenix.packages.default;}
            {package = pkgs.colmena;}
            {package = pkgs.age;}
          ];
        };
      };

      flake.homeModules = {
        xdg-autostart = self.homeProfiles.modules.xdg-autostart;
      };

      flake.nixosProfiles = haumea.lib.load {
        src = ./nixos;
        loader = haumea.lib.loaders.path;
      };

      flake.homeProfiles = haumea.lib.load {
        src = ./home;
        loader = haumea.lib.loaders.path;
      };

      flake.nixosSuites = let
        suites = self.nixosSuites;
      in
        with self.nixosProfiles; {
          base = [core.default users shell];
          main = [desktop.common];

          below = with suites; nixpkgs.lib.flatten [base main desktop.niri power];
        };

      flake.homeSuites = let
        suites = self.homeSuites;
      in
        with self.homeProfiles; {
          apps = with apps; [browser comms gaming media office emacs.default];
          desktop = with desktop; [ common appearance niri.default tools waybar secrets ];
          shell = with shell; [ssh zsh.default cli gpg ssh apps.emacs.default];

          below = with suites; nixpkgs.lib.flatten [apps desktop shell];
        };

      flake.colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
              inputs.nur.overlay
              emacs-overlay.overlay
              nix-matlab.overlay
              inputs.niri-flake.overlays.niri
            ];
          };
          specialArgs = {
            inherit self;
          };
        };
        defaults = {pkgs, ...}: let
          moduleArgs = {
            inherit
              ((getSystem "x86_64-linux").allModuleArgs)
              self'
              inputs'
              ;
            inherit self inputs;
          };
          flake-overlays = [
            nix-matlab.overlay
          ];
        in {
          imports = [
            inputs.home.nixosModules.home-manager
            inputs.agenix.nixosModules.age
            inputs.auto-cpufreq.nixosModules.default
            inputs.stylix.nixosModules.stylix
            ({pkgs, ...}: {
              imports = [ inputs.niri-flake.nixosModules.niri ];
              niri-flake.cache.enable = false;
            })
          ];
          _module.args = moduleArgs;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules =
              [
                {_module.args = moduleArgs;}
                inputs.agenix.homeManagerModules.age
              ]
              ++ builtins.attrValues self.homeModules;
          };
        };
        ryan = {
          deployment.allowLocalDeployment = true;
          deployment.targetHost = null;
          imports = [
            inputs.nixos-hardware.nixosModules.framework-16-7040-amd
            self.nixosProfiles.framework
          ];
        };
    };
  });
}
