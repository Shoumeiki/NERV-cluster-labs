# nixos/modules/services/system.nix v0.0.01
# System Service Configuration

{ config, lib, pkgs, ... }:

{
  services = {
    thermald.enable = true;
    xserver.enable = false;
    pipewire.enable = false;
    printing.enable = false;
  };
}