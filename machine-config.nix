{
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
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

    users.extraUsers.root.password = "a";

    environment.systemPackages = with pkgs; [
      firefox
      cowsay
    ];
  };
}
