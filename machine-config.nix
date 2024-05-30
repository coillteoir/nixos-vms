{
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.kernelParams = ["console=ttyS0"];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;
    boot.kernelPackages = pkgs.linuxPackages_latest-libre;

    virtualisation = {
      memorySize = 4096;
      cores = 2;
      graphics = false;
    };

    services = {
      nginx = {
        enable = true;
        virtualHosts."test.org" = {
          addSSL = true;
          enableACME = true;
          root = "/var/www/test.org";
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "hello@world.com";
    };

    users.extraUsers.root.password = "a";

    environment.systemPackages = with pkgs; [
      cowsay
      zsh
      git
      vim
    ];
  };
}
