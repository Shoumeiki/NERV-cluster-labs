# nixos/modules/services/ssh.nix v0.0.01
# SSH Service Configuration

{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      X11Forwarding = false;
      PasswordAuthentication = true;
    };
    allowSFTP = false;
  };
}