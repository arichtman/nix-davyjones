{
  description = "Nix packaging and NixOS module for davyjones";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  };

  outputs = { self, nixpkgs, ...  }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
        };
      });
    in
    {
      packages = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.rustPlatform.buildRustPackage {
          pname = "davyjones";
          version = "0.1.0";
          src = pkgs.fetchFromGitHub {
            owner = "embik";
            repo = "davyjones";
            rev = "7e1383af0ad6dbae3c1fa9e94231118a39d62dfb";
            hash = "sha256-rsVnx2ybs2fLjVCSiKh80y5P249yRVXhRuv0NSal6I8=";
          };
          cargoHash = "sha256-qMVdjXRYkveGm01TRNg2+Q9sWxA9wH9SIJShh+LhX1U=";
          meta = {
            description = "";
            homepage = "https://github.com/embik/davyjones";
            license = pkgs.lib.licenses.asl20;
            maintainers = ["embik"];
          };
        };
      });
      nixosModules = forEachSupportedSystem ({ pkgs }: {
        default = import ./module.nix;
      });
      nixosConfigurations = forEachSupportedSystem ({ pkgs, system }: {
        # test = import ./test.nix;
        test = pkgs.lib.nixosSystem {
          inherit system;
          # system = "${system}";
          # system = "x86_64-linux";
          modules = import ./module.nix;
          services.davyjones = {
            enable = true;
          };
        };
      });
    };
}
