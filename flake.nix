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
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    opencode = {
      url = "github:anomalyco/opencode?ref=v1.2.14";
    };
    #opencode-desktop = {
    #  url = "github:tomsch/opencode-desktop-nix?ref=v1.1.39";
    #};
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
    #baballonia = {
    #  url = "github:Project-Babble/Baballonia?ref=v1.1.0.9HF5";
    #};
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
