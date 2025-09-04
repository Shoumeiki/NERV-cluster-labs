# nixos/modules/base/network.nix v0.0.01
# Basic Networking Configuration

{ config, lib, pkgs, meta, ... }:

{
  networking = {
    hostName = meta.hostname;
    networkmanager.enable = true;
  };
}