# nixos/modules/base/boot.nix v0.0.02
# Boot loader and kernel configuration

{ config, lib, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "quiet" "loglevel=4" ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "fs.file-max" = 2097152;
    };
  };

  # Secure boot partition permissions
  fileSystems."/boot".options = [ "defaults" "umask=0077" "fmask=0177" "dmask=0077" ];
}