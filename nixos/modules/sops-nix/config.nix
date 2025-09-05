# nixos/modules/sops-nix/config.nix v0.0.03
# SOPS-nix secrets management configuration

{ config, lib, pkgs, meta, ... }:

{
  sops = {
    defaultSopsFile = ./secrets/default.yaml;
    defaultSopsFormat = "yaml";

    # Age key location (injected via NixAnywhere --extra-files)
    age.keyFile = "/var/lib/sops-nix/age-key.txt";
    age.generateKey = false;
    validateSopsFiles = true;

    secrets = {
      # Ellen's secrets
      "ellen/password-hash" = {
        sopsFile = ./secrets/ellen.yaml;
        neededForUsers = true; # Available during user creation
      };
      "ellen/ssh-key" = {
        sopsFile = ./secrets/ellen.yaml;
        owner = "ellen";
        group = "users";
        mode = "0600";
        path = "/home/ellen/.ssh/id_ed25519";
      };

      # K3s secrets
      "k3s/token" = {
        sopsFile = ./secrets/k3s-token.yaml;
        owner = "root";
        group = "wheel";
        mode = "0640";
      };
    };
  };

  # Ensure sops directories exist with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/sops-nix 0700 root root -"
    "d /home/ellen/.ssh 0700 ellen users -"
  ];

  # SOPS tools on primary node only
  environment.systemPackages = with pkgs;
    lib.optionals (meta.primary or false) [ sops age ];
}