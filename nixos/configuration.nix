# nixos/configuration.nix v0.0.06
# Headless Kubernetes nodes deployed via NixAnywhere

{ config, lib, pkgs, meta, ... }:

{
  imports = [
    # Load order: hardware detection first
    ./modules/base/hardware.nix
    ./modules/base/nix.nix
    ./modules/base/boot.nix
    ./modules/base/network.nix
    ./modules/base/locale.nix
    ./modules/base/packages.nix

    # Services after base system
    ./modules/services/ssh.nix
    ./modules/services/system.nix

    # Security last
    ./modules/security
  ];
}