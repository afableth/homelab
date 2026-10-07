{
  description = "NixOS k8s server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, comin, ... }:
    {
      nixosConfigurations.rtx3060 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
	  comin.nixosModules.comin
          ({
            services.comin = {
              enable = true;
              remotes = [{
                name = "origin";
                url = "https://github.com/afableth/homelab.git";
                branches.main.name = "main";
              }];
            };
          })
        ];
      };
    };
}
