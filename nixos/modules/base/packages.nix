
# nixos/modules/base/packages.nix v0.0.01
# Essential System Packages

{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
  ];
}