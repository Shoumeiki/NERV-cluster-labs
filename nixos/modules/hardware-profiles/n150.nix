# nixos/modules/hardware-profiles/n150.nix v0.0.03
# Intel N150 Processor Optimisations

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware.graphics = {
    enable = true;
    enable32Bit = false;
    extraPackages = with pkgs; [ intel-media-driver intel-vaapi-driver ];
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      "intel_pstate=enable"
      "pcie_aspm=force"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
    ];
    kernel.sysctl = {
      "vm.laptop_mode" = 5;
      "kernel.timer_migration" = 1;
    };
    blacklistedKernelModules = [ "rtw88_8821ce" "rtl8821ce" ];
  };

  hardware = {
    bluetooth.enable = false;
    wireless.enable = false;
  };
}