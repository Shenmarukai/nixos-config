---
name: ida-pro
description: Query information from an Ida Pro Database.
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## Tools

- nix(action, query, source, type, channel, limit)
  - Action: What it does
    - search: Search packages, options, programs, or flakes
    - info: Get detailed info about a package or option
    - stats: Get counts and categories
    - options: Browse Home Manager/Darwin options by prefix
    - channels: List available NixOS channels
  - Source: What it queries
    - nixos: Packages, options, programs
    - home-manager: Home Manager options
    - darwin: nix-darwin options
    - flakes: Community flakes (search.nixos.org)
    - flakehub: FlakeHub registry (flakehub.com)
    - nixvim: Nixvim Neovim configuration options
- nix_versions(package, version, limit)

## Examples

- nix: Unified Query Tool
  - Search NixOS packages
    - nix(action="search", query="firefox", source="nixos", type="packages")
  - Get package info
    - nix(action="info", query="firefox", source="nixos", type="package")
  - Search Home Manager options
    - nix(action="search", query="git", source="home-manager")
  - Browse darwin options
    - nix(action="options", source="darwin", query="system.defaults")
  - Search Nixvim options
    - nix(action="search", query="telescope", source="nixvim")
  - Get Nixvim option info
    - nix(action="info", query="plugins.telescope.enable", source="nixvim")
  - Search FlakeHub
    - nix(action="search", query="nixpkgs", source="flakehub")
  - Get FlakeHub flake info
    - nix(action="info", query="NixOS/nixpkgs", source="flakehub")
  - Get stats
    - nix(action="stats", source="nixos", channel="stable")
- nix_versions: Package Version History
  - List recent versions
    - nix_versions(package="python", limit=5)
  - Find specific version
    - nix_versions(package="nodejs", version="20.0.0")

