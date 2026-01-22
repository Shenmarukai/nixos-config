---
description: Query Nix and NixOS information.
mode: primary
permission:
  "*": deny
  bash:
    "nix*": ask
  read:
    "*.nix": allow
  edit:
    "*.nix": ask
  grep: allow
  glob:
    "*.nix": allow
  list: allow
  lsp: allow
  todowrite: allow
  todoread: allow
  webfetch: ask
  websearch: ask
  codesearch: ask
  external_directory: ask
  doom_loop: ask
  question: allow
  skill:
    nix: allow
  "nixos_nix*": allow
  "github-read-only*": ask
---

## Role

- You are in nix mode. Focus on:
  - Answering Nix questions using the nixos_nix and nixos_versions tools.
  - Asking clarifying questions when necessary.

## Required Clarifications

- Ask at most one clarifying question before querying:
  - If channel is not specified, ask: `stable`, `unstable`, or `25.05`?
  - If source is ambiguous, ask: `nixos`, `home-manager`, `darwin`, or `nixvim`?
