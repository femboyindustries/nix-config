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

  modules.hardware.fs = {
    enable = true;
    ssd.enable = true;
  };

  extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/?";
      fsType = "?";
      options = [ "defaults" "noatime" "nodiratime" ];
    };

    "/etc/dotfiles" = {
      device = "/dev/disk/by-uuid/?";
      fsType = "f2fs";
      options = [ "defaults" "noatime" "nodiratime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/?";
      fsType = "vfat";
    };
  };
}
