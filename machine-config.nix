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

    virtualisation.memorySize = 4096;
    virtualisation.cores = 2;
    virtualisation.graphics = false;

    users.extraUsers.root.password = "a";

    environment.systemPackages = with pkgs; [
      cowsay
      zsh
      git
      vim
    ];
  };
}
