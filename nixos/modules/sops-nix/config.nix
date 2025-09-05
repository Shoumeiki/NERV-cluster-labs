# nixos/modules/sops-nix/config.nix v0.0.01
# SOPS-nix secrets management configuration

{ config, lib, pkgs, meta, ... }:

{
  sops = {
    defaultSopsFile = ./secrets/default.yaml;

    # Age key location (injected via NixAnywhere --extra-files)
    age.keyFile = "/var/lib/sops-nix/age-key.txt";
    age.generateKey = false;
    validateSopsFiles = true;

    secrets = {
      # ellen's secrets
      "ellen/password-hash" = {
        sopsFile = ./secrets/ellen.yaml;
        neededForUsers = true; # Availability during user creation
      }
      "ellen/ssh-key" =  {
        sopsFile = ./secrets/ellen.yaml;
        owner = "root";
        mode = "0600";
        path = "/root/.ssh/nerv_deployment_key";
      }

      # K3s secrets
      "k3s/token" = {
        sopsFile = ./secrets/k3s-token.yaml;
        owner = "root";
        group = "wheel";
        mode = "0640";
      };
    };
  };

  # Verify sops key directories
  systemd.tmpfiles.rules = [
    "d /var/lib/sops-nix 0700 root root -"
    "z /var/lib/sops-nix/keys.txt 0600 root root -"
  ];

  # Sops tools on primary node only
  environment.systemPackages = with pkgs;
    lib.optionals meta.isPrimary [ sops age ];
}