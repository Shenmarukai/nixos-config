---
description: Reason about Nix information.
mode: subagent
reasoningEffort: high
textVerbosity: low
reasoningSummary: auto
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
---
