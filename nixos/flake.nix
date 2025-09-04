# nixos/flake.nix v0.0.05
# NERV Cluster Lab Flake

{
  description = "NERV Cluster Labs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, ... }:
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
          # Load order critical: disko first for disk setup
          disko.nixosModules.disko
          ./modules/disko/config.nix

          # Hardware detection
          ./hardware-configuration.nix
          ./modules/hardware-profiles/${nodeConfig.hardware}.nix

          # Base system configuration
          ./configuration.nix
        ];
      };
  in
  {
    nixosConfigurations = builtins.mapAttrs mkSystem nodes;

    devShells.x86_64-linux.default =
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in pkgs.mkShell {
        buildInputs = with pkgs; [ nixos-anywhere disko.packages.${pkgs.system}.disko ];
        shellHook = ''
          echo "NERV Cluster Development Environment"
          echo "Available: nixos-anywhere, disko, nix flake show"
        '';
      };
  };
}