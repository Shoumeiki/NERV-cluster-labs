# nixos/modules/base/nix.nix v0.0.02
# Nix Package Manager and System Configuration

{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system.stateVersion = "25.05";
}