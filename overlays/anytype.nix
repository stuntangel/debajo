self: super:
let
  newBuildFun = builder: update: arg: builder (finalAttrs:
    (arg finalAttrs) // update
  );
in
{
  anytype = super.anytype.override {
    buildNpmPackage = newBuildFun super.buildNpmPackage rec {
      version = "0.53.1";

      # Source update
      src = super.fetchFromGitHub {
        owner = "anyproto";
        repo = "anytype-ts";
        tag = "v${version}";
        hash = "sha256-GDx40UA+Grc/xvlfwqtN1WNonm9c0dci1rereWpfhjs=";
      };

      # locales update
      locales = super.fetchFromGitHub {
        owner = "anyproto";
        repo = "l10n-anytype-ts";
        rev = "f9dc9286757c2544fe801a1e31067cbe708cc6f1";
        hash = "sha256-/rZCpeKGtPttYbuJbhbOV4P1sXSvIYve0WO/SL20isw=";
      };

      # npm deps update
      npmDepsHash = "sha256-hJJK/RJnSm8QpjGcnxUsemrAsRNYCHSGSH8iUZZYXJI=";
    };
  };

  anytype-heart = super.anytype-heart.override {
    buildGoModule = newBuildFun super.buildGoModule rec {
      version = "0.44.0-nightly.20251220.1";

      src = super.fetchFromGitHub {
        owner = "anyproto";
        repo = "anytype-heart";
        tag = "v${version}";
        hash = "sha256-eQ7fPD/8tQBdAnu1Ze7Pn9HL4sOq0rcqG7ofhwn6OwM=";
      };

    };
  };
}
