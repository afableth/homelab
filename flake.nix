{
  description = "NixOS k8s server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      comin,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.rtx3060 = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          comin.nixosModules.comin
          ({
            environment.etc."comin/allowed_signers".text
              = "hello@afabl.fyi ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnJtuVDN563Leul7aThmEEMaMp3cFU+B0ijPGyn0lf+";
            services.comin = {
              enable = true;
              sshAllowedSignersPath = "/etc/comin/allowed_signers";
              remotes = [
                {
                  name = "origin";
                  url = "https://github.com/afableth/homelab.git";
                  branches.main.name = "main";
                }
              ];
            };
          })
        ];
      };

      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
        ];
      };
    };
}
