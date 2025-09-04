
# nixos/modules/security/default.nix v0.0.01
# Security Hardening Configuration

{ config, lib, pkgs, ... }:

{
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    protectKernelImage = true;
  };
}