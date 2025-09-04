# nixos/modules/base/hardware.nix v0.0.01
# Basic Hardware Configuration

{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  powerManagement.enable = true;
}