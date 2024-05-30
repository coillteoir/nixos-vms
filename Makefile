vm: machine-config.nix
	nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=./machine-config.nix

run: vm
	./result/bin/run-nixos-vm

clean:
	rm -rf ./nixos.qcow2 ./result/
