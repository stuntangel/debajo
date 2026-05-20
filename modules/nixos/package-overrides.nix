# PC-specific package overrides (CUDA, custom packages)
# Note: allowUnfree is set in common/nixpkgs.nix
{ pkgs, ... }:

{
# Override llama-cpp to latest version with CUDA support
 nixpkgs.config = {
    packageOverrides = pkgs: {
llama-cpp =
  (pkgs.llama-cpp.override {
    cudaSupport = false;
    rocmSupport = true;
    metalSupport = false;
    # Enable BLAS for optimized CPU layer performance (OpenBLAS)
    blasSupport = true;
  }).overrideAttrs
    (oldAttrs: rec {
      version = "8226";
      src = pkgs.fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = "b${version}";
        hash = "sha256-Z99C+SbRLimk85cypp98J6kUfiegrQqpDZcLgr/98/I=";
        leaveDotGit = true;
        postFetch = ''
          git -C "$out" rev-parse --short HEAD > $out/COMMIT
          find "$out" -name .git -print0 | xargs -0 rm -rf
        '';
      };
      # Enable native CPU optimizations (AVX, AVX2, etc.)
      cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
        "-DGGML_NATIVE=ON"
      ];
      # Disable Nix's march=native stripping
      preConfigure = ''
        export NIX_ENFORCE_NO_NATIVE=0
        ${oldAttrs.preConfigure or ""}
      '';
    });

# llama-swap from GitHub releases
llama-swap = pkgs.runCommand "llama-swap" { } ''
  mkdir -p $out/bin
  tar -xzf ${
    pkgs.fetchurl {
      url = "https://github.com/mostlygeek/llama-swap/releases/download/v175/llama-swap_175_linux_amd64.tar.gz";
      hash = "sha256-zeyVz0ldMxV4HKK+u5TtAozfRI6IJmeBo92IJTgkGrQ=";
    }
  } -C $out/bin
  chmod +x $out/bin/llama-swap
'';
  };
};
}
