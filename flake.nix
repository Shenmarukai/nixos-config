{
  description = "Shenmarukai's NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    #catppuccin = {
    #  url = "github:catppuccin/nix";
    #};
    opencode = {
      url = "github:nixos/nixpkgs/c3acb6001f1c42c4386f622bcb7e85a661d61539";
    };
    opencode-desktop = {
      url = "github:nixos/nixpkgs/48ddd1b485b3b1203b98fe12e9a82ebe09ca5e52";
    };
    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ida-pro-overlay = {
      url = "github:msanft/ida-pro-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hytale-launcher = {
      url = "github:JPyke3/hytale-launcher-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-config = {
      url = "path:../neovim-config";
      flake = false;
    };
    librewolf = {
      url = "github:nixos/nixpkgs/e4bae1bd10c9c57b2cf517953ab70060a828ee6f";
    };
    llama-cpp = {
      url = "github:ggml-org/llama.cpp?ref=b7875";
    };
    baballonia = {
      url = "github:ZenIsBestWolf/nixpkgs?ref=pkgs/baballonia";
    };
    devenv = {
      #url = "github:Shenmarukai/nixpkgs?ref=feat/devenv-opencode";
      url = "github:domenkozar/nixpkgs/f962f9d446110b36d617402641005542df1a011a";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
    };
    lmstudio = {
      url = "github:nixos/nixpkgs/0478817a4dc82a8905c2867c8a92aadfc8ded51d";
    };
  };

  outputs =
    inputs:
    let
      outputsModule = import ./flake/outputs/lib.nix;
      mkOutputs = import ./flake/outputs/default.nix;
      shared = outputsModule inputs;
      args = inputs // shared // { inherit inputs; };
    in
    mkOutputs args;
}
