{
  description = "my NVF flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, flake-parts, nixpkgs, nvf, ... } @ inputs:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    perSystem = { system, ...}:
    let
      pkgs = import nixpkgs { inherit system; };
      makeConfigurationWithLanguage = config_name: language_config: 
      (nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          ./nvf-configuration.nix
          language_config
        ];
      }).neovim;
      language_configs = {
        rust = ./languages/rust.nix;
        python = ./languages/python.nix;
        java = ./languages/java.nix;
        default = ./languages;
      };
    in {
      packages = builtins.mapAttrs makeConfigurationWithLanguage language_configs;
    };
  };
}
