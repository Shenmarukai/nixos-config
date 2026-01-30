---
description: Implement Nix code.
mode: subagent
hidden: true
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
  discard: ask
  extract: ask
---
