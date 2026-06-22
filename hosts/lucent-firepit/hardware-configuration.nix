{ config, lib, pkgs, inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelPackages = pkgs.linuxPackages_hardened;
    kernelModules = [ "kvm-amd" ];
    loader = {
      # and them squiggles steady shifting in the wind
      grub.enable = lib.mkForce false;

      systemd-boot.enable = true;
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
  #
  # edit: ghost is now dead! we're going back to true.
  # rest in piss ghost, you will be forgotten
  #
  # edit: services.writefreely.enable = true
  nix.settings.sandbox = true;

  modules.hardware.fs = {
    enable = true;
    ssd.enable = true;
    xfs.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2fb43a32-d7c2-4ed1-97c6-4588d731a132";
      fsType = "xfs";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7192-FE7C";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
