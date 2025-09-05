# nixos/flake.nix v0.0.06
# NERV Cluster Lab Flake

{
  description = "NERV Cluster Labs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, sops-nix, ... }:
  let
    nodes = {
      misato = {
        system = "x86_64-linux";
        primary = true;
        hardware = "n150";
      };
    };

    mkSystem = name: nodeConfig:
      nixpkgs.lib.nixosSystem {
        inherit (nodeConfig) system;
        specialArgs = {
          meta = {
            hostname = name;
            inherit (nodeConfig) primary;
          };
        };
        modules = [
          # Sops-nix early in the load order
          sops-nix.nixosModules.sops
          # Base system configuration
          ./configuration.nix
          ./hardware-configuration.nix
          ./modules/hardware-profiles/${nodeConfig.hardware}.nix
        ] ++ nixpkgs.lib.optionals (nodeConfig.useDisko or false) [
          disko.nixosModules.disko
          ./modules/disko/config.nix
        ];
      };
  in {
    nixosConfigurations = builtins.mapAttrs mkSystem nodes;

    devShells.x86_64-linux.default =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in pkgs.mkShell {
        buildInputs = with pkgs; [
          nixos-anywhere
          disko.packages.${pkgs.system}.disko
          sops
          age
          ssh-to-age
        ];
        shellHook = ''
          echo "NERV Cluster Development Environment"
          echo "Available: nixos-anywhere, disko, sops, age, ssh-to-age"
          echo "Run 'age-keygen -o age-key.txt' to generate age key"
        '';
      };
  };
}