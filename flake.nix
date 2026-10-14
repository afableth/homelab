{
  description = "NixOS k8s server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ddg-mcp-src = {
      url = "github:nickclyde/duckduckgo-mcp-server";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      comin,
      ddg-mcp-src,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.rtx3060 = nixpkgs.lib.nixosSystem {
        modules = [
          ./modules/configuration.nix
          ./modules/hardware-configuration.nix
          ./containers/compose.nix
          comin.nixosModules.comin
        ];
        specialArgs = {
          inherit ddg-mcp-src;
        };
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
