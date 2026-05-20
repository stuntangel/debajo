# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, config, pkgs, lib, ... }:
{
  imports = [
    flake.inputs.self.nixosModules.common
    flake.inputs.stylix.nixosModules.stylix
    flake.inputs.dankMaterialShell.nixosModules.greeter
#    flake.inputs.kooky.nixosModules.default
#    ./ai.nix
#    ./package-overrides.nix
    ({pkgs, ...}: {
      imports = [flake.inputs.niri-flake.nixosModules.niri];
      niri-flake.cache.enable = false;
    })
  ];
#  flake.nixosModules.emacs.enable = true;
#  programs.emacs-and-tools = {
#    enable = true;
#    enableDaemon = true;        # Default: Emacs daemon with emacsclient
#    includeRuntimeDeps = true;  # Default: LSP servers, fonts, CLI tools
#  };


  nixpkgs.overlays = [
    (import flake.inputs.emacs-overlay) 
  ];

  services.upower.enable = true;

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };


      environment = {
        sessionVariables = {
          EDITOR = lib.mkOverride 900 "emacseditor"; # Make sure that 'editorScript' is in pkgs set below
        };
      };

     systemd.services.emacs = {
        name = lib.mkForce "emacs";
        serviceConfig = {
          Type = "notify";
          Restart = "always";
          ExecStart = "${pkgs.runtimeShell} -c 'source ${config.system.build.setEnvironment}; exec ${pkgs.emacs}/bin/emacs --fg-daemon'";
          SuccessExitStatus = 15;
        };
        wantedBy = [ "default.target" ];
      };

  services.openssh.enable = true;
  services.openssh.openFirewall = lib.mkDefault false;
  services.libinput.enable = true;
  services.acpid.enable = true;
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;
  services.power-profiles-daemon.enable = true; # Enables powerprofilesctl for terminal-based power mode switching
  services.fwupd.enable = true;
  environment.etc."fwupd/fwupd.conf".text = lib.mkForce ''
    [fwupd]
    UpdateOnBoot=true
  '';

  services.fprintd.enable = true;
  #security.pamservices = {
  #  login.fprintAuth = true;
  #  sudo.fprintAuth = true;
  #};

  boot.supportedFilesystems = ["exfat"];

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = lib.mkIf (pkgs.system == "x86_64-linux") true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs;
          [
            # My package wrapped emacs
#            (pkgs.emacsWithPackagesFromUsePackage {
#	      package = pkgs.emacsPgtk;  # replace with pkgs.emacsPgtk, or another version if desired.
#      	      config = ./Emacs.org;
      	      # config = path/to/your/config.org; # Org-Babel configs also supported
 	      # Optionally provide extra packages not in the configuration file.
#	      extraEmacsPackages =  epkgs: [
#                            ace-window; # Better window navigation
#            babel; # Babel languages setup
#            breadcrumb; # Works well with eglot
#            cape; # Provides Completion At Point Extensions
#            colorful-mode; # Highlight CSS Colors
#            consult; # Set up minibuffer actions and
#            consult-dir; # Really good package to traverse long distance directories using minibuffer
#            #consult-eglot # Consult+eglot
#            #consult-eglot-embark # Consult + embark + eglot
#            consult-notes; # For managing notes
#            #consult-org-roam
#            consult-projectile; # Needed for consult-project-switch, I guess(?)
#            consult-todo;
#            corfu; # Completion UI
#            dash; # It's a library that's needed by emacs for a lot of things
#            dashboard;
#            diff-hl;
#            dired-open-with; # Open files with external programs form dired
#            dirvish; # best dired extension, no mini-packages
#            doom-modeline;
#            doom-themes; # For tokyo-night theme
#            #eglot # Lightweight lsp engine
#            eglot-booster; # Make eglot faster
#            elfeed;
#            elfeed-dashboard;
#            #elfeed-org;
#            emacs;
#            embark;
#            embark-consult;
#            #embark-org-roam;
#            emms; # For Music player
#            envrc; # Integrate emacs with direnv
#            eshell-git-prompt;
#            eshell-vterm;
#            exec-path-from-shell;
#            forge;
#            hl-todo; # Highlight the TODO keywords in a lot of buffers
#            indent-bars; # Indentation guide bars
#            info-colors; # Prettify info mode
#            json-mode;
#            ligature;
#            magit;
#            marginalia;
#            markdown-mode;
#            media-progress-dirvish; # display media progress in dirvish
#            multiple-cursors;
#            multi-vterm; # Manage multiple vterm buffers
#            nerd-icons;
#            nerd-icons-completion;
#            nerd-icons-corfu;
#            nerd-icons-grep;
#            nerd-icons-ibuffer;
#            nerd-icons-xref;
#            nixfmt; # https://github.com/purcell/emacs-nixfmt for editing nix
#            # nix-mode # Already using nix-ts-mode
#            nix-ts-mode;
#            no-littering;
#            olivetti;
#            orderless;
#            #org;
#            org-auto-tangle;
#            org-dashboard;
            #org-modern

#            (callPackage ./packages/_org-modern-indent.nix {
#              inherit (pkgs) fetchFromGitHub;
#              inherit (epkgs) melpaBuild;
#            });

#            (callPackage ./packages/_emacs-reader.nix {
#              inherit (pkgs)
#                fetchFromGitea
#                pkg-config
#                gcc
#                mupdf
#                gnumake
 #               ;

#              inherit (epkgs) melpaBuild;
#            });

            #org-roam
            #org-roam-ui
#            page-break-lines;
            # pdf-tools # For opening pdf's inside of emacs
#            projectile;
#            projectile-ripgrep;
#            pulsar; # Cool cursor animations in emacs when changing b/w contexts
#            rainbow-delimiters; # colorful delimiters
#            ripgrep;
#            saveplace-pdf-view; # To save the last visited information in pdf-mode
#            shfmt;
#            smartparens; # For auto-parenthesis
#            tab-line-nerd-icons;
#            transient; # Used for improving UI
#            treemacs; # For the side line filemanager
#            treemacs-nerd-icons; # For icons in header line

            # Tree-sitter
#            (treesit-grammars.with-grammars (
#              grammars: with grammars; [
#                tree-sitter-bash
#                tree-sitter-c
#                tree-sitter-nix
#              ]
#            ));

#            use-package # Basic necessity
#            vertico; # completion ui
#            vterm # Terminal inside emacs
#            vterm-toggle;
#            which-key; # YKI
#            with-editor; # handle $EDITOR in different in-emacs environment
#            with-emacs;
#            yasnippet;
#      	      ];
#   	    })
            # Editor Environment variable
            # Set the $EDITOR to emacseditor with lib.mkOverride 900
#            editorScript

            # Support for dictionaries
#            (aspellWithDicts (
#              dicts: with dicts; [
#                en
#                en-computers
#                en-science
#              ]
#            ))

#            fd
#            ripgrep
#            ripgrep-all

#            bash-language-server # bash-language server
#            clang-tools # For C development format
#            emacs-lsp-booster # Dependency for eglot-booster
#            ffmpegthumbnailer # For ready-player
#            ffmpeg-full # For ready-player
#            imagemagick # For rendering images inside org
#            mediainfo # For viewing mediainfo inside emacs
#            mpg123 # For music decoding in ready player
#            nixd # nix server
#            nixfmt # for formatting nix

            # TODO: write an issue for using mupdf's mutool for pdf preview in dirvish.
            # poppler # For viewing pdf metadata
#            poppler-utils # for pdftoppm utility

            # Not needed when using emacs-reader package
            # poppler # For pdf reading

#            shfmt # for formatting bash
#            mupdf

#            unzip # For Unzipping zip files
#            vips # Has vlpsthumbnail for image preview in dirvish
#            _7zz-rar # for archive files preview

            # Emacsclient needs to be restarted after every rebuild
#            (pkgs.writeShellScriptBin "remacs" ''
#              systemctl --user restart emacs
#            '')

            # Alias for emacsclient
            #(pkgs.writeShellScriptBin "ec" ''
            #  ${myEmacs}/bin/emacsclient -a \"\" -c $@
            #'')

            #(pkgs.writeShellScriptBin "epkgs" ''
            #  nix-env -f '<nixpkgs>' -qaP -A services
            #'')
#          ] ++ [
    tuigreet
    config.stylix.cursor.package
    flake.inputs.winapps.packages.x86_64-linux.winapps
    flake.inputs.winapps.packages.x86_64-linux.winapps-launcher # optional
    podman-compose
    freerdp
  ];

  programs.dankMaterialShell.greeter = {
    enable = true;
    configHome = "/home/ryan/";
    compositor.name = "niri";
    compositor.customConfig = ''
      output "eDP-1" {
        scale 1.5
        transform "normal"
      }
      cursor {
        xcursor-theme "ComixCursors-Green"
        xcursor-size 24
      }
    '';
    logs.save = true;
  };

  services.greetd = {
    enable = true;
    settings = let
      tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      default_session = {
        command = "${tuigreet} --greeting 'Lucky' --asterisks --remember --remember-user-session";
      };
    in {
      inherit default_session;
    };
  };
}
