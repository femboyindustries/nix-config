{ pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.loader.grub.device = "/dev/sda";

  boot.kernelPackages = pkgs.linuxPackages_hardened;
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

  powerManagement.cpuFreqGovernor = "performance";

  networking = let
    ipv6 = "2001:41d0:623:4bf::1";
    gateway = "2001:41d0:623::1";
    prefix = 128;
  in {
    interfaces.ens3.ipv6.addresses = [{
      address = ipv6;
      prefixLength = prefix;
    }];
    defaultGateway6  = {
      address = gateway;
      interface = "ens3";
    };
  };
}
