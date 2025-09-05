# nixos/modules/services/ssh.nix v0.0.01
# SSH Service Configuration

{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes"; # TODO: create user for SSH
      X11Forwarding = false;
      PasswordAuthentication = true; # TODO: Enable SSH keys
    };
    allowSFTP = false;
  };
}