# nixos/flake-manual-install.nix v0.0.01
# NERV Cluster Lab Flake Without Disko

{
  description = "NERV Cluster Labs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs,  ... }:
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
          # Base system configuration
          ./configuration.nix

          # Hardware detection
          ./hardware-configuration.nix
          ./modules/hardware-profiles/${nodeConfig.hardware}.nix
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