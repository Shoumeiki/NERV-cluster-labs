# nixos/modules/sops-nix/users.nix v0.0.01
# User management with SOPS-managed secrets

{ config, lib, pkgs, ... }:

{
  users = {
    mutableUsers = false;  # All users managed declaratively

    users.ellen = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      hashedPasswordFile = config.sops.secrets."ellen/password-hash".path;
      openssh.authorizedKeys.keys = [
        # SSH keys will be managed here or via sops
      ];
    };
    users.root = {
      # Disable root SSH in production
      openssh.authorizedKeys.keys = [ ];
    };
  };

  # SSH hardening
  services.openssh.settings = {
    PermitRootLogin = lib.mkForce "yes"; # TODO: disable once SSH keys are working
    PasswordAuthentication = true; # TODO: disable once SSH keys are working
    ChallengeResponseAuthentication = false;
  };
}