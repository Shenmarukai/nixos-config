---
description: Implement Cargo code.
mode: subagent
model: lmstudio/qwen3-30b-a3b-instruct-2507
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
