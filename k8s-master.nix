{
  pkgs,
  lib,
  ...
}:
with lib; let
  kubeMasterIP = "10.1.1.2";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
in {
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

    virtualisation.cores = 2;
    virtualisation.graphics = false;
    virtualisation.memorySize = 4096;

    users.extraUsers.root.password = "a";

    environment.systemPackages = with pkgs; [
      kompose
      kubectl
      kubernetes
      vim
    ];

    networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
    networking.hostName = "kooberneets";

    systemd.services.onStartup = {
      description = "init script for master node";
      script = ''
        mkdir -p /root/.kube
        ln -s /etc/kubernetes/cluster-admin.kubeconfig /root/.kube/config
      '';
      wantedBy = ["multi-user.target"];
    };

    services.kubernetes = {
      roles = ["master" "node"];
      masterAddress = kubeMasterHostname;
    };
  };
}
