# nixos/modules/sops-nix/users.nix v0.0.02
# User management with SOPS-managed secrets

{ config, lib, pkgs, ... }:

{
  users = {
    mutableUsers = false; # All users managed declaratively

    users.ellen = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.sops.secrets."ellen/password-hash".path;
      createHome = true;
      home = "/home/ellen";

      openssh.authorizedKeys.keys = [
        # Public keys can go here, or be managed via SOPS
      ];
    };

    users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+uyNEXXNnR82kfMFYd3TrQHjyirW24ECFqppAoR+pW root@misato";
      ];
    };
  };
}