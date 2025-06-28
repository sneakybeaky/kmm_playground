{
  description =
    "This flake builds kmm using Nix's buildGoModule Function.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # kmm is not a flake, so we have to use the Github input and build it ourselves.
    kmm = {
      type = "github";
      owner = "bruth";
      repo = "kmm";
      ref = "main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, kmm }:
    # Use the flake-utils lib to easily create a multi-system flake
    flake-utils.lib.eachDefaultSystem (system:
      let
        version = "0.0.1";
      in
      {
        packages =
          let
            pkgs = import nixpkgs { inherit system; };
            pname = "kmm";
            name = "kmm-${version}";
          in
          {
            # Build kmm using Nix's buildGoModuleFunction
            kmm = pkgs.buildGoModule {
              inherit version;
              inherit pname;
              inherit name;

              src = kmm;

              vendorHash = "sha256-e5b38SKKHQja0/85vsFLBLUGQc+5IeqV9ehmp14xZHY=";

              doCheck = false;

            };
          };
      }
    );
}
