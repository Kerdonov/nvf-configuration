# My very minimal NVF configuration

>See [NVF](https://github.com/NotAShelf/nvf) for the original repo.

## Importing to a flake based system
```nix
# system flake.nix
{
  inputs.nvf.url = "github:Kerdonov/nvf-configuration";
  
  outputs = { self, ... } @ inputs: 
  let
    system = "x86_64-linux";
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

```nix
# configuration.nix
{ config, lib, pkgs, ... } @ inputs: {
  # ...
  environment.systemPackages = with pkgs; [
    # ...
    inputs.customNeovim
  ];
}
```

## Using the language based builds in other flakes

```nix
# flake.nix
{
  description = "java devenv example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvf.url = "github:Kerdonov/nvf-configuration";
  };

  outputs = { self, nixpkgs, nvf, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        nvf.packages.${system}.java
        pkgs.jdk
      ];
      shellHook = ''
        PS1='\[\e[32m\]\u\[\e[0m\]@java-devenv:\[\e[34m\]\w\[\e[0m\]\$ '
        echo "java devenv..."
      '';
    };
  };
}
```