# nixos/modules/base/boot.nix v0.0.01
# Boot loader and kernel Configuration

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
}