k8s: k8s-master.nix
	nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=./k8s-master.nix

vm: machine-config.nix
	nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=./machine-config.nix

run: vm
	./result/bin/run-nixos-vm

k8s-run: k8s
	./result/bin/run-kooberneets-vm

clean:
	rm -rf ./nixos.qcow2 ./result/
