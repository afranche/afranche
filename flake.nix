{
  description = "afranche";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.devshell.inputs.nixpkgs.follows = "nixpkgs";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, devshell }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell =
        let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [ devshell.overlays.default ];
            config.allowUnfree = true;
          };
        in
          pkgs.devshell.mkShell {
            devshell.name = "portfolio";
            devshell.packages = with pkgs; [
              bun
              volta
            ];
            env = [
              {
                name = "VOLTA_HOME";
                eval = "$PWD/.volta";
              }
              {
                name = "PATH";
                prefix = ".volta/bin";
              }
            ];
          };
      });
}
