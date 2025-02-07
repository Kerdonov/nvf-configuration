# My very minimal NVF configuration

## importing to a flake based system
flake.nix
```nix
{
  inputs.nvf.url = "github:Kerdonov/nvf-configuration";
  
  outputs = { self, ... } @ inputs: 
  let
    system = "x86_64-linux"; # your system type
    customNeovim = inputs.nvf.packages.${system}.default;
  in {
    nixosConfigurations.cappuccino = nixpkgs.lib.nixosSystem {
      modules = [
        # ...
        ./configuration.nix
      ];
      specialArgs = {
	    inherit customNeovim;
      };
    };
  };
}
```

configuration.nix
```nix
{ config, lib, pkgs, ... } @ inputs: {
  # ...
  environment.systemPackages = with pkgs; [
    # ...
    inputs.customNeovim
  ];
}
```