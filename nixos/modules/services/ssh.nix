# nixos/modules/services/ssh.nix v0.0.02
# SSH Service Configuration

{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      # Gradual security lockdown
      PermitRootLogin = "yes";          # TODO: Set to "no" once user keys working
      PasswordAuthentication = true;    # TODO: Set to false once keys working
      X11Forwarding = false;
      ChallengeResponseAuthentication = false;
      PubkeyAuthentication = true;
    };
    allowSFTP = false;
  };
}