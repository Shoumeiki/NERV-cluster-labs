# nixos/modules/disko/config.nix v0.0.02
# File System and Storage Layout

# Storage layout: ESP boot + Btrfs root with k3s-optimised subvolumes

{ config, lib, pkgs, meta, ... }:

{
  disko.devices = {
    disk = {
      primary = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1025M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                mountOptions = [ "defaults" "ssd" "discard=async" ];
                mountpoint = "/partition-root";
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd:1" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd:1" "noatime" "space_cache=v2" ];
                  };
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd:3" "noatime" ];
                  };
                  "/var/lib/rancher" = {
                    mountpoint = "/var/lib/rancher";
                    mountOptions = [ "compress=zstd:1" "noatime" ];
                  };
                  "/var/lib/longhorn" = {
                    mountpoint = "/var/lib/longhorn";
                    mountOptions = [ "noatime" "space_cache=v2" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}