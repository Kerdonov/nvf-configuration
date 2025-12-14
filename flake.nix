{
  description = "my NVF flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    flake-parts,
    nixpkgs,
    nvf,
    ...
  } @ inputs: let
    configModule = import ./default.nix;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      #flake.nixosModules.default = configModule;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {system, ...}: let
        pkgs = import nixpkgs {inherit system;};
        makeConfigurationWithLanguage = config_name: language_config:
          (nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              configModule
              {
                programs.nii-vaga-fun.enable = true;
                programs.nii-vaga-fun.languages = language_config;
              }
            ];
          }).neovim;
        language_configurations = {
          rust = ["rust"];
          python = ["python"];
          java = ["java"];
          web = ["web"];
          nix = ["nix"];
          tidal = ["tidal"];
          c = ["c"];
          asm = ["asm"];
          typst = ["typst"];
          default = ["rust" "pyton" "java" "web" "nix" "c" "asm" "typst"];
        };
      in {
        packages = builtins.mapAttrs makeConfigurationWithLanguage language_configurations;
      };
    };
}
