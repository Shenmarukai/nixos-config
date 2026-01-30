---
description: Plan Cargo code.
mode: subagent
hidden: true
permission:
  "*": deny
  bash:
    "cargo*": ask
  read:
    "Cargo.toml": allow
    "Cargo.lock": allow
  edit:
    "Cargo.toml": ask
  grep: allow
  glob:
    "Cargo.toml": allow
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
