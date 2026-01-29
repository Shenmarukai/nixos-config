---
description: Research Nix information.
mode: subagent
model: lmstudio/qwen3-30b-a3b-instruct-2507
hidden: true
permission:
  "*": deny
  bash:
    "nix*": ask
  read:
    "*.nix": allow
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
  discard: ask
  extract: ask
  "nixos_nix*": allow
  "github-read-only*": ask
---
