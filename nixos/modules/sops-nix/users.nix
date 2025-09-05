# nixos/modules/sops-nix/users.nix v0.0.02
# User management with SOPS-managed secrets

{ config, lib, pkgs, ... }:

{
  users = {
    mutableUsers = false;  # All users managed declaratively

    users.ellen = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.sops.secrets."ellen/password-hash".path;

      # Create SSH directory for authorised keys
      createHome = true;
      home = "/home/ellen";

      openssh.authorizedKeys.keys = [
        # SSH keys will be managed here or via sops
      ];
    };
    users.root = {
      # Disable root SSH in production
      openssh.authorizedKeys.keys = [ ];
    };
  };

  # SSH hardening - gradual lockdown
  services.openssh.settings = {
    PermitRootLogin = lib.mkForce "yes"; # TODO: Set to "no" once keys working
    PasswordAuthentication = true;       # TODO: Set to false once keys working
    ChallengeResponseAuthentication = false;
    PubkeyAuthentication = true;
  };
}