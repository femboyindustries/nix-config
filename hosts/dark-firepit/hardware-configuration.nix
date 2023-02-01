{ config, lib, pkgs, inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelPackages = pkgs.linuxPackages_hardened;
    kernelModules = [ "kvm-intel" ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nix.settings.cores = 3;
  nix.settings.max-jobs = 6;

  # disabling this is what's considered a "Bad Idea"
  # however it is required by packages/ghost.nix, which
  # is borrowed from https://notes.abhinavsarkar.net/2022/ghost-on-nixos
  #
  # i don't know of a cleaner way to do this, and i
  # don't want to deal with ghost any longer than i
  # already have, so This Will Do
  nix.settings.sandbox = false;

  modules.hardware.fs = {
    enable = true;
    ssd.enable = true;
    xfs.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/819f03bb-73d2-4ae1-9fd2-01099e8efae6";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/D018-F9AF";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/01ba93e4-71e3-404d-9549-351e22130185"; }
    { device = "/dev/disk/by-uuid/dee63218-1666-4035-8d63-b9e0e0b2cd28"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
