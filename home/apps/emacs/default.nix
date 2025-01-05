{
  pkgs,
  config,
  ...
}: {
   programs = {
  	emacs = {
  	  enable = true;
  	  # package = pkgs.emacs-pgtk;
  	  package = (pkgs.emacsWithPackagesFromUsePackage {
  	    package = pkgs.emacs-unstable-pgtk;
  	    config = ./config.org;
  	    alwaysEnsure = false;
  	    alwaysTangle = true;
  	   # extraEmacsPackages = epkgs: with epkgs; [
  	      #
  	   # ];
  	  });
  	};
     };
}
