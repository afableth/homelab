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
          ./modules/main.nix
          comin.nixosModules.comin
        ];
      };

      packages.${system}.default = self.nixosConfigurations.rtx3060.config.system.build.toplevel;
      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
        ];
      };
    };
}
